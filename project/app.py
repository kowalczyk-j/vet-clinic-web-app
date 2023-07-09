from datetime import datetime

from flask import Flask, render_template, request, jsonify, redirect, flash, session
from sqlalchemy.exc import IntegrityError, OperationalError

from src.data_access import get_owner_by_id, get_all_owners, add_owner, update_owner, delete_owner, \
    get_all_appointments, get_employee_by_id, get_animal_by_id, get_room_by_id, add_appointment, \
    get_procedures_with_appointment, delete_appointment, get_all_vets, get_all_rooms, \
    get_all_procedures, get_latest_appointment, add_procedure_to_appointment, \
    get_pending_payments, get_payments_history, update_payment, get_owners_animals, delete_animal, \
    get_invoice_from_payment, update_appointments_date_time, get_employee_schedule, get_vet_by_id, \
    add_animal, get_animal_disease_history
from src.invoices.invoice_generator import generate_invoice_pdf

app = Flask(__name__)
app.secret_key = "NF83nd9sD"


@app.route('/')
def home():
    return redirect('/patients')


@app.route('/calendar')
def calendar():
    doctors_data = [{
        'vet_id': vet.vet_id,
        'name': get_employee_by_id(vet.employee_id).name,
        'surname': get_employee_by_id(vet.employee_id).surname,
        'spec': vet.specialization,
    } for vet in get_all_vets()]

    rooms_data = [{
        'room_id': room.room_id,
        'room_number': room.room_number,
        'type': room.room_type,
    } for room in get_all_rooms()]

    animal_data = [{
        'animal_id': animal.animal_id,
        'name': animal.name,
        'species': animal.species,
        'owner_name': owner.name,
        'owner_surname': owner.surname,
    } for owner in get_all_owners() for animal in get_owners_animals(owner)]

    treatment_data = [{
        'procedure_id': procedure.procedure_id,
        'name': procedure.name,
    } for procedure in get_all_procedures()]

    appointments_table = []

    for appointment in get_all_appointments():
        animal, owner, vet, room = get_appointment_details(appointment)
        procedures = get_procedures_with_appointment(appointment)
        procedures_names = ', '.join(p.name for p in procedures)
        appointment_data = {
            'id': appointment.appointment_id,
            'date': appointment.date,
            'time': appointment.time,
            'doctor': f"{vet.name} {vet.surname}",
            'room': room.room_number,
            'animal': f"{animal.species} {animal.name} (Właściciel: {owner.name} {owner.surname})",
            'procedures': procedures_names,
            'owner_id': owner.owner_id,
        }
        appointments_table.append(appointment_data)
    return render_template('calendar.html',
                           appointments=appointments_table,
                           doctors=doctors_data,
                           rooms=rooms_data,
                           procedures=treatment_data,
                           animals=animal_data)


@app.route('/send_appointments')
def send_appointments_data_to_calendar():
    calendar_data = []

    for appointment in get_all_appointments():
        appointment_datetime = datetime.combine(appointment.date, appointment.time)
        animal, owner, vet, room = get_appointment_details(appointment)
        calendar_tile = {
            'title': f"{animal.name} ({owner.surname}) \n dr. {vet.name} {vet.surname} \n Sala {room.number}",
            'start': appointment_datetime.isoformat(),
            'end': (appointment_datetime + appointment.duration).isoformat(),
            'color': '#00bcd4',
        }
        calendar_data.append(calendar_tile)

    return jsonify(calendar_data)


def get_appointment_details(appointment):
    animal = get_animal_by_id(appointment.animal_id)
    owner = get_owner_by_id(animal.owner_id)
    vet = get_vet_by_id(appointment.vet_id)
    vet_employee = get_employee_by_id(vet.employee_id)
    room = get_room_by_id(appointment.room_id)
    return animal, owner, vet_employee, room


@app.route('/get_schedule', methods=['POST', 'GET'])
def get_schedule():
    if request.method == 'POST':
        employee_id = int(request.form.get('doctor_dropdown'))
        employee_schedule = get_employee_schedule(get_employee_by_id(employee_id))
        employee_name = f'dr. {get_employee_by_id(employee_id).name} {get_employee_by_id(employee_id).surname}'
        events = [{
            'title': employee_name,
            'daysOfWeek': str(day.week_day - 1),
            'startTime': day.hour_start.isoformat(),
            'endTime': day.hour_end.isoformat()
        } for day in employee_schedule]
        session['events'] = events
        flash(f'Pomyślnie wczytano grafik: {employee_name}', 'success')
        return redirect('/schedule')

    if request.method == 'GET':
        events = session.get('events', [])
        return jsonify(events)


@app.route('/schedule')
def schedule():
    doctors_data = []
    for vet in get_all_vets():
        vet_employee = get_employee_by_id(vet.employee_id)
        doctors_data.append({
            'employee_id': vet_employee.employee_id,
            'name': vet_employee.name,
            'surname': vet_employee.surname,
            'spec': vet.specialization,
        })
    events = session.get('events', [])
    return render_template('schedule.html', doctors=doctors_data, events=events)


@app.route('/add_appointment', methods=['POST'])
def add_appointment_route():
    date = request.form.get('date')
    time = request.form.get('time')
    doctor_id = request.form.get('doctor')
    room_id = request.form.get('room')
    animal_id = request.form.get('animal')
    selected_procedures = request.form.getlist('treatments')
    procedure_ids = [int(procedure_id) for procedure_id in selected_procedures]
    if not procedure_ids:
        flash('Wystąpił błąd. Nie wybrano żadnego zabiegu.', 'error')
        return redirect(request.referrer)
    if not all([date, time, doctor_id, room_id, animal_id]):
        flash('Wystąpił błąd. Nie wypełniono wszystkich pól.', 'error')
        return redirect(request.referrer)
    try:
        add_appointment(doctor_id, room_id, animal_id, date, time)
        for procedure_id in procedure_ids:
            add_procedure_to_appointment(get_latest_appointment().appointment_id, procedure_id)
        flash('Wizyta została dodana pomyślnie.', 'success')
    except OperationalError as e:
        error_message = str(e)
        if 'Vet is not available at that time' in error_message:
            flash('Wystąpił błąd. Lekarz nie jest dostępny o podanej godzinie.', 'error')
        elif 'Room is not available at that time' in error_message:
            flash('Wystąpił błąd. Sala nie jest dostępna o podanej godzinie.', 'error')
        else:
            flash('Wystąpił błąd podczas dodawania wizyty. Spróbuj ponownie.', 'error')
    return redirect(request.referrer)


@app.route('/delete_appointment/<appointment_id>', methods=['POST'])
def delete_appointment_route(appointment_id):
    try:
        delete_appointment(appointment_id)
        flash(f'Wizyta o id {appointment_id} została usunięta pomyślnie.', 'success')
    except (IntegrityError, OperationalError):
        flash(f'Wystąpił błąd podczas usuwania wizyty o id {appointment_id}. Spróbuj ponownie.', 'error')
    return redirect(request.referrer)


@app.route('/postpone_appointment/<appointment_id>', methods=['POST'])
def postpone_appointment(appointment_id):
    new_day = request.form['new_day']
    start_hour = request.form['start_hour']
    if start_hour < '09:00' or start_hour > '19:00':
        flash('Nie można umówić wizyty. Godziny pracy kliniki to 9:00 - 19:00', 'error')
        return redirect('/calendar')
    try:
        update_appointments_date_time(appointment_id, new_day, start_hour)
        flash(f"Wizyta o id {appointment_id} została przełożona. Nowa data: {start_hour} {new_day}", "success")
    except OperationalError as e:
        error_message = str(e)
        if 'Vet is not available at that time' in error_message:
            flash('Lekarz nie jest dostępny o podanej godzinie. Dodaj wizytę na nowo, wybierając innego lekarza.',
                  'error')
        elif 'Cannot update appointment. No available room.' in error_message:
            flash('Żadna z sal nie jest dostępna. Wybierz inny termin.', 'error')
        else:
            flash("Wystąpił błąd podczas przekładania wizyty. Usuń wizytę i dodaj ją na nowo.", "error")
    return redirect('/calendar')


@app.route('/payments')
def payments():
    pending_payments = get_pending_payments()
    payment_history = get_payments_history()
    return render_template('payments.html', pending_payments=pending_payments, payment_history=payment_history)


@app.route('/process_payment/<payment_id>/<method_id>/<invoice>', methods=['POST'])
def process_payment(payment_id, method_id, invoice):
    flash_message = "Opłacono wizytę"
    update_payment(payment_id, method_id)
    if invoice == "1":
        invoice_data = get_invoice_from_payment(payment_id)
        generate_invoice_pdf(invoice_data)
        flash_message += " oraz pobrano fakturę."
    flash(flash_message, "success")
    return redirect("/payments")


@app.route('/patients')
def patients():
    owners = get_all_owners()
    return render_template('patients.html', owners=owners)


@app.route('/patients/<int:owner_id>')
def profile(owner_id):
    owner = get_owner_by_id(owner_id)
    animals = get_owners_animals(owner)
    diseases = {}
    for animal in animals:
        diseases[animal.animal_id] = get_animal_disease_history(animal.animal_id)
    return render_template('profile.html', owner=owner, animals=animals, diseases=diseases)


@app.route('/add_owner', methods=['POST'])
def add_owner_route():
    name = request.form['name']
    surname = request.form['surname']
    street = request.form['street']
    postal_code = request.form['postal code']
    city = request.form['city']
    address = f"ul. {street}, {postal_code} {city}"
    phone_number = request.form['phone_number']
    pesel = request.form['pesel']
    if not all([name, surname, street, postal_code, city, phone_number, pesel]):
        flash('Wystąpił błąd. Proszę wypełnić wszystkie pola.', "error")
    else:
        try:
            add_owner(name, surname, address, phone_number, pesel)
            flash("Poprawnie zarejestrowano nowego klienta", "success")
        except IntegrityError:
            flash("Wystąpił błąd. Podany numer pesel jest już zarejestrowany w bazie danych.", "error")
    return redirect(request.referrer)


@app.route('/edit_owner/<pesel>', methods=['POST'])
def edit_owner(pesel):
    form_dict = {
        'name': request.form['name'],
        'surname': request.form['surname'],
        'address': request.form['address'],
        'phone_number': request.form['phone_number']
    }
    args_dict = {key: value for key, value in form_dict.items() if value}
    if not args_dict:
        flash("Wystąpił błąd. Nie podano danych do edycji.", "error")
    else:
        update_owner(pesel, **args_dict)
        flash("Dane właściciela zostały zmienione.", "success")
    return redirect(request.referrer)


@app.route('/delete_owner/<pesel>', methods=['POST'])
def delete_owner_route(pesel):
    try:
        delete_owner(pesel)
        flash("Właściciel i wszystkie powiązane z nim dane zostały pomyślnie usunięte.", "success")
    except IntegrityError:
        flash("Wystąpił błąd. Nie można usunąć właściciela.", "error")
    return redirect(request.referrer)


@app.route('/add_animal', methods=['POST'])
def add_animal_route():
    name = request.form['name']
    animal_type = request.form['type']
    species = request.form['species']
    gender = request.form['gender']
    birthdate = request.form['birthdate']
    owner_id = request.referrer.split('/')[-1]
    if not all([name, animal_type, species, gender, birthdate]):
        flash('Wystąpił błąd. Proszę wypełnić wszystkie pola.', 'error')
    else:
        try:
            add_animal(owner_id, name, species, animal_type, gender, birthdate)
            flash(f"Poprawnie zarejestrowano nowe zwierzę ({animal_type} {name}).", "success")
        except OperationalError:
            flash("Wystąpił błąd. Podana data urodzenia jest z przyszłości", "error")
    return redirect(request.referrer)


@app.route('/delete_animal/<animal_id>', methods=['POST'])
def delete_animal_route(animal_id):
    try:
        delete_animal(animal_id)
        flash("Poprawnie usunięto zwierzę i jego dane z bazy.", "success")
    except (IntegrityError, OperationalError):
        flash("Wystąpił błąd. Nie można usunąć zwierzęcia.", "error")
    return redirect(request.referrer)


if __name__ == '__main__':
    app.run(debug=True)
