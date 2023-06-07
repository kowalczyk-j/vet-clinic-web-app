from flask import Flask, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, timedelta


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///calendawr.db'
db = SQLAlchemy(app)



class Appointment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.DateTime, nullable=False)
    time = db.Column(db.DateTime, nullable=False)
    doctor = db.Column(db.String(100), nullable=False)
    room = db.Column(db.String(10), nullable=False)
    animal = db.Column(db.String(50), nullable=False)
    appointment_duration = db.Column(db.Integer, nullable=False)


    def __repr__(self):
        return f"Appointment(date='{self.date.strftime('%Y-%m-%d')}', time='{self.time}', room='{self.room}, animal='{self.animal}, doctor='{self.doctor} ')"


@app.route('/')
def home():
    return render_template('home.html')

@app.route('/calendar')
def index():
    appointments = Appointment.query.all()
    return render_template('calendar.html', appointments=appointments)

@app.route('/appointments')
def get_appointments():
    appointments = Appointment.query.all()
    appointments_data = []

    for appointment in appointments:
        duration = timedelta(minutes=appointment.appointment_duration) 
        end = appointment.time + duration
        appointment_data = {
            'title': appointment.doctor,
            'start': appointment.time.strftime("%Y-%m-%d %H:%M:%S"),
            'end': end.strftime("%Y-%m-%d %H:%M:%S"),
        }
        appointments_data.append(appointment_data)

    return jsonify(appointments_data)

@app.route('/EmployeeCalendar')
def about():
    return render_template('EmpCalendar.html')


if __name__ == '__main__':
    with app.app_context():
        db.create_all()

        # Check if the appointments already exist in the database
        existing_appointments = Appointment.query.filter(
            Appointment.date.between(datetime(2023, 6, 8), datetime(2023, 6, 9))
        ).all()

        if not existing_appointments:
            # Add the appointments if they don't exist
            appointment1 = Appointment(
                date=datetime(2023, 6, 8),
                time=datetime(2023, 6, 8, 10, 1, 0),
                animal='Tajemnicza',
                doctor='Dr. Kasia Kwiatkowska',
                room='002',
                appointment_duration=15
            )

            appointment2 = Appointment(
                date=datetime(2023, 6, 8),
                time=datetime(2023, 6, 8, 15, 30, 0),
                animal='Monika',
                doctor='Dr. Grazyna Strozyna',
                room='202',
                appointment_duration=30
            )

            db.session.add(appointment1)
            db.session.add(appointment2)
            db.session.commit()

    app.run(debug=True)


