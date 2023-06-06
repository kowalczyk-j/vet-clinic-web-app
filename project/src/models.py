from sqlalchemy import create_engine, MetaData, Table

tables = [
    "animal",
    "appointment",
    "disease",
    "disease_history",
    "employee",
    "employee_schedule",
    "examination",
    "inventory",
    "medical_equipment",
    "medical_procedure",
    "owner",
    "payment",
    "payment_method",
    "position",
    "procedure_appointment",
    "room",
    "room_medical_equipment",
    "unit_of_measure",
    "vet"
]

engine = create_engine(
    "mysql+pymysql://root:root_password@localhost:3306/bd2_23l_z31")

metadata = MetaData()

for table in tables:
    exec(f"{table} = Table('{table}', metadata, autoload_with=engine)")
