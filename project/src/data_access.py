from src.models import (animal, appointment, disease, disease_history, employee,
                    employee_schedule, examination, medical_procedure, owner,
                    payment, procedure_appointment, vet, engine)
from sqlalchemy import select, insert
from sqlalchemy.orm import Session


def execute_statement(statement):
    with Session(engine) as session:
        result = session.execute(statement)
        session.commit()
    return result

def get_all_owners():
    stmt = select(owner)
    return execute_statement(stmt)

# ----------- OWNER -----------


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


def get_vets_appointments(vet_row):
    stmt = (select(appointment).join(vet)
            .where(appointment.c.vet_id == vet_row.vet_id))
    return execute_statement(stmt).all()


# ----------- APPOINTMENTS -----------


def get_appointment_by_id(id):
    stmt = select(appointment).where(appointment.c.appointment_id == id)
    return execute_statement(stmt).first()


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
