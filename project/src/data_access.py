from src.models import (animal, appointment, disease, disease_history, employee,
                        employee_schedule, examination, medical_procedure, owner,
                        payment, payment_method, procedure_appointment, vet, engine, room)
from sqlalchemy import select, insert, delete, update, or_, and_, func
from sqlalchemy.orm import Session
from datetime import date, datetime


def execute_statement(statement):
    with Session(engine) as session:
        result = session.execute(statement)
        session.commit()
    return result


# ----------- OWNER -----------


def get_all_owners():
    stmt = select(owner)
    return execute_statement(stmt)


def get_owner_by_id(id):
    stmt = select(owner).where(owner.c.owner_id == id)
    result = execute_statement(stmt)
    return result.first()


def get_owner_by_pesel(pesel):
    stmt = select(owner).where(owner.c.pesel == pesel)
    result = execute_statement(stmt)
    return result.first()


def get_owners_animals(owner_row):
    # owner_row is the return value of get_owner_by_id or get_owner_by_pesel
    stmt = select(animal).join(owner).where(owner.c.pesel == owner_row.pesel)
    return execute_statement(stmt).all()


def get_owners_appointments(owner_row):
    stmt = (select(appointment)
            .join_from(appointment, animal,
                       appointment.c.animal_id == animal.c.animal_id)
            .join_from(animal, owner, animal.c.owner_id == owner.c.owner_id)
            .where(owner.c.pesel == owner_row.pesel))
    return execute_statement(stmt).all()


def get_owners_payments(owner_row):
    appointments = get_owners_appointments(owner_row)
    appointment_ids = [a.appointment_id for a in appointments]
    stmt = select(payment).where(payment.c.appointment_id.in_(appointment_ids))
    return execute_statement(stmt).all()


def add_owner(name, surname, address, phone_number, pesel):
    stmt = insert(owner).values(name=name, surname=surname,
                                address=address, phone_number=phone_number,
                                pesel=pesel)
    execute_statement(stmt)


def update_owner(pesel, **kwargs):
    stmt = update(owner).where(owner.c.pesel == pesel).values(kwargs)
    execute_statement(stmt)


def delete_owner(pesel):
    stmt = delete(owner).where(owner.c.pesel == pesel)
    execute_statement(stmt)


# ----------- ANIMAL -----------


def get_animal_by_id(id):
    stmt = select(animal).where(animal.c.animal_id == id)
    return execute_statement(stmt).first()


def get_animal_by_name_and_owner(owner_row, animal_name):
    animals = get_owners_animals(owner_row)
    for a in animals:
        if a.name == animal_name:
            return a
    return None


def get_animal_disease_history(animal_row):
    stmt = (select(disease_history, disease.c.name)
            .join_from(disease_history, animal,
                       disease_history.c.animal_id == animal.c.animal_id)
            .join_from(disease_history, disease,
                       disease_history.c.disease_id == disease.c.disease_id)
            .where(animal.c.animal_id == animal_row.animal_id))
    return execute_statement(stmt).all()


def get_animals_examinations(animal_row):
    stmt = (select(examination)
            .where(examination.c.animal_id == animal_row.animal_id))
    return execute_statement(stmt).all()


def get_animal_appointments(animal_row):
    stmt = (select(appointment)
            .where(appointment.c.animal_id == animal_row.animal_id))
    return execute_statement(stmt).all()


def add_animal(owner_id, name, species, type, gender, birthdate):
    stmt = insert(animal).values(owner_id=owner_id, name=name, species=species,
                                 type=type, gender=gender,
                                 birthdate=birthdate)
    execute_statement(stmt)


# ----------- VET -----------


def get_vet_by_id(id):
    stmt = select(vet).where(vet.c.vet_id == id)
    return execute_statement(stmt).first()

def get_all_vets():
    stmt = select(vet)
    return execute_statement(stmt).all()
def get_vets_appointments(vet_row):
    stmt = (select(appointment).join(vet)
            .where(appointment.c.vet_id == vet_row.vet_id))
    return execute_statement(stmt).all()


# ----------- APPOINTMENTS -----------


def get_appointment_by_id(id):
    stmt = select(appointment).where(appointment.c.appointment_id == id)
    return execute_statement(stmt).first()

def get_latest_appointment():
    stmt = select(appointment).order_by(appointment.c.appointment_id.desc()).limit(1)
    return execute_statement(stmt).first()

def get_all_appointments():
    subq = (select(procedure_appointment.c.appointment_id,
                   func.sec_to_time(
                       func.sum(
                           func.time_to_sec(
                               medical_procedure.c.estimate_time)))
                   .label("duration"))
            .join(procedure_appointment)
            .group_by(procedure_appointment.c.appointment_id)
            .subquery())

    stmt = select(appointment, subq.c.duration).join(subq).order_by(appointment.c.date, appointment.c.time)
    return execute_statement(stmt).all()


def get_all_future_appointments():
    current_time = datetime.now().time()
    subq = subq = (select(procedure_appointment.c.appointment_id,
                          func.sec_to_time(
                              func.sum(
                                  func.time_to_sec(
                                      medical_procedure.c.estimate_time)))
                          .label("duration"))
                   .join(procedure_appointment)
                   .group_by(procedure_appointment.c.appointment_id)
                   .subquery())
    stmt = (select(appointment, subq.c.duration).where(
        or_(and_(appointment.c.time >= current_time,
                 appointment.c.date == date.today()),
            appointment.c.date > date.today())).join(subq))
    return execute_statement(stmt).all()


def get_all_past_appointments():
    current_time = datetime.now().time()
    subq = (select(procedure_appointment.c.appointment_id,
                   func.sec_to_time(
                       func.sum(
                           func.time_to_sec(
                               medical_procedure.c.estimate_time)))
                   .label("duration"))
            .join(procedure_appointment)
            .group_by(procedure_appointment.c.appointment_id)
            .subquery())
    stmt = (select(appointment, subq.c.duration).where(
        or_(and_(appointment.c.time < current_time,
                 appointment.c.date == date.today()),
            appointment.c.date < date.today())).join(subq))
    return execute_statement(stmt).all()


def get_procedures_with_appointment(appointment_row):
    stmt = (select(medical_procedure)
            .join_from(medical_procedure, procedure_appointment,
                       medical_procedure.c.procedure_id == procedure_appointment.c.procedure_id)
            .join_from(procedure_appointment, appointment,
                       procedure_appointment.c.appointment_id == appointment.c.appointment_id)
            .where(appointment.c.appointment_id == appointment_row.appointment_id))
    return execute_statement(stmt).all()


def get_appointment_payment(appointment_row):
    stmt = (select(payment).join(appointment)
            .where(appointment.c.appointment_id == appointment_row.appointment_id))
    return execute_statement(stmt).all()


def add_appointment(vet_id, room_id, animal_id, date, time):
    stmt = insert(appointment).values(vet_id=vet_id, room_id=room_id,
                                      animal_id=animal_id, date=date,
                                      time=time)
    execute_statement(stmt)


def delete_appointment(appointment_id):
    stmt = delete(appointment).where(appointment.c.appointment_id == appointment_id)
    execute_statement(stmt)


def add_procedure_to_appointment(appointment_id, procedure_id):
    stmt = insert(procedure_appointment).values(
        appointment_id=appointment_id, procedure_id=procedure_id)
    execute_statement(stmt)


# ----------- EMPLOYEES -----------


def get_employee_by_id(id):
    stmt = select(employee).where(employee.c.employee_id == id)
    return execute_statement(stmt).first()


def get_employee_schedule(employee_row):
    stmt = (select(employee_schedule).join(employee).
            where(employee_schedule.c.employee_id == employee_row.employee_id))
    return execute_statement(stmt).all()


# ----------- ROOMS -----------

def get_all_rooms():
    stmt = select(room)
    return execute_statement(stmt).all()


def get_room_by_id(id):
    stmt = select(room).where(room.c.room_id == id)
    return execute_statement(stmt).first()


# ----------- PAYMENTS -----------


def get_pending_payments():
    stmt = (select(owner.c.name, owner.c.surname, owner.c.pesel,
                   payment.c.appointment_id, payment.c.amount, payment.c.payment_id)
            .join_from(payment, appointment,
                       payment.c.appointment_id == appointment.c.appointment_id)
            .join_from(appointment, animal,
                       appointment.c.animal_id == animal.c.animal_id)
            .join_from(animal, owner, owner.c.owner_id == animal.c.owner_id)
            .where(payment.c.date_paid == None))
    return execute_statement(stmt).all()


def get_payments_history():
    stmt = (select(owner.c.name, owner.c.surname, owner.c.pesel,
                   payment.c.appointment_id, payment.c.date_paid,
                   payment_method.c.name.label("method_of_payment"),
                   payment.c.amount)
            .join_from(payment, payment_method,
                       payment.c.method_id == payment_method.c.method_id)
            .join_from(payment, appointment,
                       payment.c.appointment_id == appointment.c.appointment_id)
            .join_from(appointment, animal,
                       appointment.c.animal_id == animal.c.animal_id)
            .join_from(animal, owner, owner.c.owner_id == animal.c.owner_id)
            .where(payment.c.date_paid != None))
    return execute_statement(stmt).all()


def update_payment(payment_id, method_id):
    stmt = (update(payment)
            .where(payment.c.payment_id == payment_id)
            .values({payment.c.method_id: method_id,
                     payment.c.date_paid: datetime.now()}))
    return execute_statement(stmt)


# ----------- PROCEDURES -----------
def get_all_procedures():
    stmt = select(medical_procedure).order_by(medical_procedure.c.name)
    return execute_statement(stmt).all()
