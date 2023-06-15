from sqlalchemy.exc import OperationalError
from flask import Flask, render_template, request, jsonify, redirect, flash
from sqlalchemy.exc import IntegrityError, OperationalError
from datetime import datetime
from src.data_access import get_owner_by_id, get_all_owners, add_owner, update_owner, delete_owner, \
    get_all_appointments, get_employee_by_id, get_animal_by_id, get_room_by_id, add_appointment, \
    get_procedures_with_appointment, delete_appointment, get_all_vets, get_all_rooms, \
    get_owners_animals, get_all_procedures, get_latest_appointment, add_procedure_to_appointment, \
    get_pending_payments, get_payments_history, update_payment, get_owners_animals, delete_animal, \
    get_invoice_from_payment
from src.invoices.invoice_generator import generate_invoice_pdf

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
        animal_name, animal_species, owner_name, owner_surname, vet_name, vet_surname, room_number = get_appointment_details(
            appointment)
        procedures = get_procedures_with_appointment(appointment)
        appointment_data = {
            'id': appointment.appointment_id,
            'date': appointment.date,
            'time': appointment.time,
            'doctor': f"{vet_name} {vet_surname}",
            'room': room_number,
            'animal': f"{animal_species} {animal_name} (Właściciel: {owner_name} {owner_surname})",
            'procedures': ', '.join(p.name for p in procedures)
        }
        table_data.append(appointment_data)
    return render_template('calendar.html',
                           appointments=table_data,
                           doctors=doctors_data,
                           rooms=rooms_data,
                           procedures=treatment_data,
                           animals=animal_data)


@app.route('/get-patient-info', methods=['POST'])
def get_patient_info():
    data = request.get_json()
    pesel = data['pesel']

    if pesel == '123':
        patient = {
            'name': 'John Doe',
            'age': 35,
            'address': '123 Main Street'
        }

        return jsonify({'patient': patient})
    patient = {
        'name': 'Tajemniczy bebzol',
        'age': 35,
        'address': '123 Main Street'
    }
    return jsonify({'patient': patient})


@app.route('/send-appointments')
def send_appointments_data_to_calendar():
    appointments = get_all_appointments()
    calendar_data = []

    for appointment in appointments:
        appointment_datetime = datetime.combine(
            appointment.date, appointment.time)
        animal_name, animal_species, owner_name, owner_surname, vet_name, vet_surname, room_number = get_appointment_details(
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
    return animal.name, animal.species, owner.name, owner.surname, vet.name, vet.surname, room.room_number


@app.route('/add-appointment', methods=['POST'])
def add_appointment_route():
    date = request.form.get('date')
    time = request.form.get('time')
    doctor_id = request.form.get('doctor')
    room_id = request.form.get('room')
    animal_id = request.form.get('animal')
    procedure_id = request.form.get('procedure')

    try:
        add_appointment(doctor_id, room_id, animal_id, date, time)
        add_procedure_to_appointment(
            get_latest_appointment().appointment_id, procedure_id)
        flash('Wizyta została dodana pomyślnie.', 'success')
    except OperationalError as e:
        error_message = str(e)
        if 'Vet is not available at that time' in error_message:
            flash('Wystąpił błąd. Lekarz nie jest dostępny o podanej godzinie.', 'error')
        else:
            flash('Wystąpił błąd podczas dodawania wizyty. Spróbuj ponownie.', 'error')
    return redirect('/calendar')


@app.route('/remove-appointment', methods=['POST'])
def remove_appointment():
    data = request.get_json()  # Odczytaj dane z ciała żądania jako JSON
    appointment_id = data.get('id')  # Pobierz ID wizyty z danych JSON
    # Dodaj kod usuwający wizytę o podanym ID z bazy danych lub innej struktury danych
    try:
        if get_latest_appointment().appointment_id < int(appointment_id):
            raise ValueError
        delete_appointment(appointment_id)
        # Zwróć odpowiedź potwierdzającą usunięcie wizyty
        return f'Wizyta o ID {appointment_id} została pomyślnie usunięta.'
    except ValueError as e:
        return jsonify({'error': str(e)}), 400


@app.route('/schedule')
def schedule():
    return render_template('schedule.html')


@app.route('/payments')
def payments():
    pending_payments = get_pending_payments()
    payment_history = get_payments_history()
    return render_template('payments.html', pending_payments=pending_payments, payment_history=payment_history)


@app.route('/process_payment/<payment_id>/<method_id>/<invoice>', methods=['POST'])
def process_payment(payment_id, method_id, invoice):
    flash_message = "Opłacono wizytę "
    update_payment(payment_id, method_id)
    if invoice == "1":
        invoice_data = get_invoice_data(payment_id)
        generate_invoice_pdf(invoice_data)
        flash_message += "oraz pobrano fakturę"
    flash(flash_message, "success")
    return redirect("/payments")


def get_invoice_data(payment_id):
    raw_data = get_invoice_from_payment(payment_id)
    invoice_data = {
        "nabywca": {
            "imie_nazwisko": f"{raw_data.name} {raw_data.surname}",
            "adres": raw_data.address,
        },
        "data_sprzedazy": raw_data.date,
        "data_oplaty": raw_data.date_paid,
        "sposob_platnosci": raw_data.method_of_payment,
        "pozycje": [
            {
                "opis": "Konsultacja weterynaryjna",
                "ilosc": 1,
                "cena_brutto": float(raw_data.amount),
                "wartosc": float(raw_data.amount),
            }
        ],
    }
    return invoice_data


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


@app.route('/delete_animal/<animal_id>', methods=['POST'])
def delete_animal_route(animal_id):
    delete_animal(animal_id)
    return redirect(request.referrer)


if __name__ == '__main__':
    app.secret_key = "rootpasswd"
    app.run(debug=True)
