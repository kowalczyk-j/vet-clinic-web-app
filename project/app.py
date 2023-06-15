from flask import Flask, render_template, request, jsonify, redirect, flash, abort
from sqlalchemy.exc import IntegrityError, OperationalError
from datetime import datetime
from src.data_access import get_owner_by_id, get_all_owners, add_owner, update_owner, delete_owner, \
    get_all_appointments, get_employee_by_id, get_animal_by_id, get_room_by_id, add_appointment, \
    get_procedures_with_appointment, delete_appointment, get_all_vets, get_all_rooms, \
    get_owners_animals, get_all_procedures, get_latest_appointment, add_procedure_to_appointment, \
    get_pending_payments, get_payments_history, update_payment, get_owners_animals, update_appointments_date_time, \
    get_employee_schedule

app = Flask(__name__)


@app.route('/')
def home():
    return render_template('home.html')


@app.route('/calendar')
def calendar():
    appointments = get_all_appointments()

    doctors_data = []
    for vet in get_all_vets():
        vet_employee = get_employee_by_id(vet.employee_id)
        doctors_data.append({
            'vet_id': vet.vet_id,
            'name': vet_employee.name,
            'surname': vet_employee.surname,
            'spec': vet.specialization,
        })
    rooms_data = []
    for room in get_all_rooms():
        rooms_data.append({
            'room_id': room.room_id,
            'room_number': room.room_number,
            'type': room.room_type,
        })

    animal_data = []
    for owner in get_all_owners():
        for animal in get_owners_animals(owner):
            animal_data.append({
                'animal_id': animal.animal_id,
                'name': animal.name,
                'species': animal.species,
                'owner_name': owner.name,
                'owner_surname': owner.surname,
            })

    treatment_data = []
    for procedure in get_all_procedures():
        treatment_data.append({
            'procedure_id': procedure.procedure_id,
            'name': procedure.name,
        })

    table_data = []

    for appointment in appointments:
        animal_name, animal_species, owner_name, owner_surname, owner_id, vet_name, vet_surname, room_number = get_appointment_details(
            appointment)
        procedures = get_procedures_with_appointment(appointment)
        appointment_data = {
            'id': appointment.appointment_id,
            'date': appointment.date,
            'time': appointment.time,
            'doctor': f"{vet_name} {vet_surname}",
            'room': room_number,
            'animal': f"{animal_species} {animal_name} (Właściciel: {owner_name} {owner_surname})",
            'procedures': ', '.join(p.name for p in procedures),
            'owner_id': owner_id,
        }
        table_data.append(appointment_data)
    return render_template('calendar.html',
                           appointments=table_data,
                           doctors=doctors_data,
                           rooms=rooms_data,
                           procedures=treatment_data,
                           animals=animal_data)


@app.route('/send-appointments')
def send_appointments_data_to_calendar():
    appointments = get_all_appointments()
    calendar_data = []

    for appointment in appointments:
        appointment_datetime = datetime.combine(
            appointment.date, appointment.time)
        animal_name, animal_species, owner_name, owner_surname, owner_id, vet_name, vet_surname, room_number = get_appointment_details(
            appointment)
        calendar_tile = {
            'title': f"{animal_name} ({owner_surname}) \n dr. {vet_name} {vet_surname} \n Sala {room_number}",
            'start': appointment_datetime.isoformat(),
            'end': (appointment_datetime + appointment.duration).isoformat(),
            'color': '#00bcd4',
        }
        calendar_data.append(calendar_tile)

    return jsonify(calendar_data)


def get_appointment_details(appointment):
    animal = get_animal_by_id(appointment.animal_id)
    owner = get_owner_by_id(animal.owner_id)
    vet = get_employee_by_id(appointment.vet_id)
    room = get_room_by_id(appointment.room_id)
    return animal.name, animal.species, owner.name, owner.surname, owner.owner_id, vet.name, vet.surname, room.room_number


@app.route('/add-appointment', methods=['POST'])
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
        return redirect('/calendar')
    if not date or not time or not doctor_id or not room_id or not animal_id:
        flash('Wystąpił błąd. Nie wypełniono wszystkich pól.', 'error')
        return redirect('/calendar')
    try:
        add_appointment(doctor_id, room_id, animal_id, date, time)
        for procedure_id in procedure_ids:
            print(procedure_id)
            add_procedure_to_appointment(get_latest_appointment().appointment_id, procedure_id)
        flash('Wizyta została dodana pomyślnie.', 'success')
    except OperationalError as e:
        error_message = str(e)
        if 'Vet is not available at that time' in error_message:
            flash('Wystąpił błąd. Lekarz nie jest dostępny o podanej godzinie.', 'error')
        else:
            flash('Wystąpił błąd podczas dodawania wizyty. Spróbuj ponownie.', 'error')
    return redirect('/calendar')


@app.route('/delete_appointment/<appointment_id>', methods=['POST'])
def delete_appointment_route(appointment_id):
    try:
        delete_appointment(appointment_id)
        flash(f'Wizyta o id {appointment_id} została usunięta pomyślnie.', 'success')
    except IntegrityError:
        flash(f'Wystąpił błąd podczas usuwania wizyty o id {appointment_id}. Spróbuj ponownie.', 'error')
    except OperationalError:
        flash(f'Wystąpił błąd podczas usuwania wizyty o id {appointment_id}. Spróbuj ponownie.', 'error')
    return redirect('/calendar')


@app.route('/postpone_appointment/<appointment_id>', methods=['POST'])
def postpone_appointment_route(appointment_id):
    new_day = request.form['new_day']
    start_hour = request.form['start_hour']
    try:
        update_appointments_date_time(appointment_id, new_day, start_hour)
        flash(f"Wizyta o id {appointment_id} została przełożona. Nowa data: {start_hour} {new_day}", "success")
    except OperationalError:
        flash(f"Wystąpił błąd podczas przekładania wizyty. Spróbuj ponownie.", "error")
    return redirect('/calendar')


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
    return render_template('schedule.html', doctors=doctors_data)

@app.route('/get_schedule', methods=['POST', 'GET'])
def get_schedule():
    if request.method == 'POST':
        employee_id = int(request.form.get('doctor_dropdown'))
        employee_schedule = get_employee_schedule(get_employee_by_id(employee_id))
        events = []
        for schedule in employee_schedule:
            event = {
                'title': 'Praca',
                'daysOfWeek': schedule.week_day,
                'startTime': schedule.hour_start.isoformat(),
                'endTime': schedule.hour_end.isoformat(),
            }
            events.append(event)

        return jsonify(events)
    return redirect('/schedule')

@app.route('/payments')
def payments():
    pending_payments = get_pending_payments()
    payment_history = get_payments_history()
    return render_template('payments.html', pending_payments=pending_payments, payment_history=payment_history)


@app.route('/process_payment/<payment_id>/<method_id>', methods=['POST'])
def process_payment(payment_id, method_id):
    update_payment(payment_id, method_id)
    return redirect("/payments")


@app.route('/patients')
def patients():
    owners = get_all_owners()
    return render_template('patients.html', owners=owners)


@app.route('/patients/<int:owner_id>')
def profile(owner_id):
    owner = get_owner_by_id(owner_id)
    animals = get_owners_animals(owner)
    return render_template('profile.html', owner=owner, animals=animals)


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
    if (not name or not surname or not street or not postal_code
            or not city or not phone_number or not pesel):
        flash('Wystąpił błąd. Proszę wypełnić wszystkie pola.', 'error')
    else:
        try:
            add_owner(name, surname, address, phone_number, pesel)
            flash("Poprawnie zarejestrowano klienta!", "success")
        except IntegrityError:
            flash("Wystąpił błąd. Podany numer pesel jest już zarejestrowany \
                   w bazie danych.", "error")
    return redirect('/patients')


@app.route('/edit_owner/<pesel>', methods=['POST'])
def edit_owner_route(pesel):
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
        flash("Dane właściciela zostały zmienione.")
    return redirect('/patients')


@app.route('/delete_owner/<pesel>', methods=['POST'])
def delete_owner_route(pesel):
    delete_owner(pesel)
    return redirect('/patients')


if __name__ == '__main__':
    app.secret_key = "rootpasswd"
    app.run(debug=True)
