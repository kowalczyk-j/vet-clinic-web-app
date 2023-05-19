create database bd2_23l_z31;

use bd2_23l_z31;

CREATE TABLE owner (
    owner_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone_number VARCHAR(12) NOT NULL,
    pesel VARCHAR(11) NOT NULL,
    PRIMARY KEY (owner_id),
    CONSTRAINT unique_pesel UNIQUE (pesel)
);

CREATE TABLE animal (
  animal_id INT NOT NULL AUTO_INCREMENT,
  owner_id INT,
  name VARCHAR(50) NOT NULL,
  species VARCHAR(50) NOT NULL,
#   SHOULD BE NEW ENTITY WITH SPECIES
  type VARCHAR(50),
  gender CHAR(1) CONSTRAINT gender_check CHECK (gender IN ('F', 'M')),
  birthdate DATE,
  PRIMARY KEY (animal_id),
  FOREIGN KEY (owner_id) REFERENCES owner(owner_id) ON DELETE CASCADE
);

CREATE TABLE disease (
  disease_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50),
  PRIMARY KEY (disease_id)
);

CREATE TABLE disease_history (
  history_id INT NOT NULL AUTO_INCREMENT,
  animal_id INT NOT NULL,
  disease_id INT NOT NULL,
  diagnosis_date DATE,
  recovery_date DATE,
  description VARCHAR(255),
  PRIMARY KEY (history_id),
  FOREIGN KEY (animal_id) REFERENCES animal(animal_id),
  FOREIGN KEY (disease_id) REFERENCES disease(disease_id)
);

CREATE TABLE medical_procedure (
  procedure_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(100),
  estimate_time TIME,
  PRIMARY KEY (procedure_id)
);

CREATE TABLE position (
  position_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(100),
  salary_min DECIMAL(7, 2),
  salary_max DECIMAL(7, 2),
  PRIMARY KEY (position_id)
);

CREATE TABLE employee (
  employee_id INT NOT NULL AUTO_INCREMENT,
  position_id INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  phone_number VARCHAR(12) NOT NULL UNIQUE,
  address VARCHAR(100) NOT NULL,
  salary DECIMAL(7, 2) NOT NULL,
  employment_date DATE,
  bonus DECIMAL(7, 2),
  PRIMARY KEY (employee_id)
);

ALTER TABLE employee
ADD CONSTRAINT FK_employee_position
FOREIGN KEY (position_id) REFERENCES position (position_id);

CREATE TABLE vet (
  vet_id INT NOT NULL AUTO_INCREMENT,
  employee_id INT NOT NULL UNIQUE,
  specialization VARCHAR(50),
  PRIMARY KEY (vet_id),
  FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE room (
  room_id INT NOT NULL AUTO_INCREMENT,
  room_number VARCHAR(3),
  type VARCHAR(50),
  PRIMARY KEY (room_id)
);

CREATE TABLE appointment (
  appointment_id INT NOT NULL AUTO_INCREMENT,
  vet_id INT,
  room_id INT,
  animal_id INT NOT NULL,
  date DATE,
  time TIME,
  PRIMARY KEY (appointment_id),
  FOREIGN KEY (vet_id) REFERENCES vet(vet_id),
  FOREIGN KEY (room_id) REFERENCES room(room_id),
  FOREIGN KEY (animal_id) REFERENCES animal(animal_id)
);

CREATE TABLE procedure_appointment (
    appointment_id INT NOT NULL,
    procedure_id INT NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    FOREIGN KEY (procedure_id) REFERENCES medical_procedure(procedure_id)
);

CREATE TABLE employee_schedule (
  schedule_id INT NOT NULL AUTO_INCREMENT,
  employee_id INT NOT NULL,
  week_day CHAR(3) NOT NULL,
  hour_start TIME,
  hour_end TIME,
  PRIMARY KEY (schedule_id),
  FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE payment_method (
  method_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(20),
  PRIMARY KEY (method_id)
);

CREATE TABLE payment (
  payment_id INT NOT NULL AUTO_INCREMENT,
  appointment_id INT NOT NULL,
  method_id INT NOT NULL,
  amount DECIMAL(6, 2),
  date_paid DATETIME,
  PRIMARY KEY (payment_id),
  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
  FOREIGN KEY (method_id) REFERENCES payment_method(method_id)
);

CREATE TABLE examination (
  examination_id INT NOT NULL AUTO_INCREMENT,
  animal_id INT NOT NULL,
  vet_id INT NOT NULL,
  date DATE,
  result VARCHAR(255),
  PRIMARY KEY (examination_id),
  FOREIGN KEY (animal_id) REFERENCES animal(animal_id),
  FOREIGN KEY (vet_id) REFERENCES vet(vet_id)
);

CREATE TABLE unit_of_measure (
  unit_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL UNIQUE,
  short VARCHAR(3),
  PRIMARY KEY (unit_id)
);

CREATE TABLE inventory (
  object_id INT NOT NULL AUTO_INCREMENT,
  unit_id INT,
  name VARCHAR(50) NOT NULL,
  amount DECIMAL(8, 2),
  best_before DATE,
  PRIMARY KEY (object_id),
  FOREIGN KEY (unit_id) REFERENCES unit_of_measure(unit_id)
);

CREATE TABLE medical_equipment (
  equipment_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50),
  description VARCHAR(100),
  PRIMARY KEY (equipment_id)
);

CREATE TABLE room_medical_equipment (
  room_equip_id INT NOT NULL AUTO_INCREMENT,
  equipment_id INT NOT NULL,
  room_id INT,
  last_inspection DATE,
  next_inspection DATE,
  PRIMARY KEY (room_equip_id),
  FOREIGN KEY (equipment_id) REFERENCES medical_equipment(equipment_id),
  FOREIGN KEY (room_id) REFERENCES room(room_id)
);



DELIMITER //
CREATE TRIGGER check_last_inspection_date
BEFORE INSERT ON room_medical_equipment
FOR EACH ROW
BEGIN
  IF NEW.last_inspection IS NULL OR NEW.last_inspection > NOW() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid inspection date';
  END IF;
END //


CREATE TRIGGER check_payment_timestamp
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
  IF NEW.date_paid IS NULL OR NEW.date_paid > NOW() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid payment timestamp';
  END IF;
END //


CREATE TRIGGER check_animal_birthdate
BEFORE INSERT ON animal
FOR EACH ROW
BEGIN
  IF NEW.birthdate IS NULL OR NEW.birthdate > CURDATE() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid animal birthdate';
  END IF;
END //


CREATE TRIGGER check_employment_date
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
  IF NEW.employment_date IS NULL OR NEW.employment_date > CURDATE() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid employment date';
  END IF;
END //


CREATE TRIGGER check_disease_timetable
BEFORE INSERT ON disease_history
FOR EACH ROW
BEGIN
  IF (NEW.recovery_date IS NULL OR NEW.recovery_date > CURDATE())
  AND (NEW.diagnosis_date IS NULL OR NEW.diagnosis_date > CURDATE())
  THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid diagnosis date or recovery date';
  END IF;
END //


CREATE TRIGGER check_number_format
BEFORE INSERT ON owner
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.phone_number) != 9 OR NEW.phone_number NOT REGEXP '^[0-9]+$' THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Invalid phone number format';
    END IF;
END //


CREATE TRIGGER check_owner_existence
BEFORE INSERT ON animal
FOR EACH ROW
BEGIN
DECLARE owner_id_exists INT;

SELECT 1 INTO owner_id_exists
FROM owner
WHERE owner_id = NEW.owner_id
LIMIT 1;

IF owner_id_exists IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cannot add animal without an existing owner';
END IF;
END //
DELIMITER ;
