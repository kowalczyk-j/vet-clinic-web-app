from models import owner, engine
from sqlalchemy import select, insert
from sqlalchemy.orm import Session


def execute_statement(statement):
    with Session(engine) as session:
        result = session.execute(statement)
        session.commit()
    return result


def get_owner_by_id(id):
    stmt = select(owner).where(owner.c.owner_id == id)
    return execute_statement(stmt)


def get_owner_by_pesel(pesel):
    stmt = select(owner).where(owner.c.pesel == pesel)
    return execute_statement(stmt)


def add_owner(name, surname, address, phone_number, pesel):
    stmt = insert(owner).values(name=name, surname=surname,
                                address=address, phone_number=phone_number,
                                pesel=pesel)
    return execute_statement(stmt)
