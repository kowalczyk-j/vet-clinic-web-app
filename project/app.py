from flask import Flask, render_template, request, jsonify, redirect, flash, url_for
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from src.data_access import get_owner_by_id, get_all_owners, add_owner, get_all_appointments, \
    get_employee_by_id, get_animal_by_id, get_room_by_id, add_appointment

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///calendawr.db'
db = SQLAlchemy(app)


@app.route('/')
def home():
    return render_template('home.html')


@app.route('/calendar')
def calendar():
    appointments = get_all_appointments()
    table_data = []

    for appointment in appointments:
        animal_name, animal_species, owner_name, owner_surname, vet_name, vet_surname, room_number = get_appointment_details(
            appointment)
        appointment_data = {
            'date': appointment.date,
            'time': appointment.time,
            'doctor': f"{vet_name} {vet_surname}",
            'room': room_number,
            'animal': f"{animal_species} {animal_name} (Właściciel: {owner_name} {owner_surname})"
        }
        table_data.append(appointment_data)
    return render_template('calendar.html', appointments=table_data)


@app.route('/send-appointments')
def send_appointments_data_to_calendar():
    appointments = get_all_appointments()
    calendar_data = []

    for appointment in appointments:
        appointment_datetime = datetime.combine(appointment.date, appointment.time)
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
    add_appointment(doctor_id, room_id, animal_id, date, time)
    flash('Wizyta została dodana pomyślnie.', 'success')
    return redirect('/calendar')


@app.route('/schedule')
def schedule():
    return render_template('schedule.html')


@app.route('/payments')
def payments():
    # pending_payments = get_pending_payments()
    # payments_history = get_payments_history()
    # return render_template('payments.html', pending_payments=pending_payments, payments_history=payments_history)
    return render_template('payments.html')


@app.route('/patients')
def patients():
    owners = get_all_owners()
    return render_template('patients.html', owners=owners)


@app.route('/add_owner', methods=['POST'])
def add_owner_route():
    name = request.form['name']
    surname = request.form['surname']
    address = request.form['address']
    phone_number = request.form['phone_number']
    pesel = request.form['pesel']
    add_owner(name, surname, address, phone_number, pesel)
    return redirect('/patients')


if __name__ == '__main__':
    app.secret_key = "rootpasswd"
    app.run(debug=True)
