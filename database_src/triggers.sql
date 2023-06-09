use bd2_23l_z31;

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
  IF NEW.date_paid > NOW() THEN
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
  IF NEW.employment_date > CURDATE() THEN
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


CREATE TRIGGER check_duplicate_appointment_animal_insert
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM appointment
        WHERE animal_id = NEW.animal_id
        AND appointment_id != NEW.appointment_id
        AND date = NEW.date
        AND time = NEW.time
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Animal already has appointment at that time';
    END IF;
END //


CREATE TRIGGER check_duplicate_appointment_animal_update
BEFORE UPDATE ON appointment
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM appointment
        WHERE animal_id = NEW.animal_id
        AND appointment_id != NEW.appointment_id
        AND date = NEW.date
        AND time = NEW.time
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Animal already has appointment at that time';
    END IF;
END //


CREATE TRIGGER prevent_appointments_in_past
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
  IF NEW.date < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot create appointment in the past';
  END IF;
END //


CREATE TRIGGER prevent_appointment_updates_in_past
BEFORE UPDATE ON appointment
FOR EACH ROW
BEGIN
  IF NEW.date < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot reschedule appointment into the past';
  END IF;
END //


CREATE TRIGGER check_vet_availability_insert
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
  DECLARE num_appointments INT;
  SET num_appointments = (
      SELECT COUNT(*) FROM appointment a
      WHERE a.vet_id = NEW.vet_id
      AND a.date = NEW.date
      AND a.time <= NEW.time
      AND a.time + (SELECT SUM(mp.estimate_time) FROM medical_procedure mp
                    JOIN procedure_appointment pa on mp.procedure_id = pa.procedure_id
                    WHERE mp.procedure_id = pa.procedure_id
                    AND pa.appointment_id = a.appointment_id) >= NEW.time
  );
  IF num_appointments != 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vet already has appointment at that time';
  END IF;
END //


CREATE TRIGGER check_vet_availability_update
BEFORE UPDATE ON appointment
FOR EACH ROW
BEGIN
  DECLARE num_appointments INT;
  SET num_appointments = (
      SELECT COUNT(*) FROM appointment a
      WHERE a.vet_id = NEW.vet_id
      AND a.date = NEW.date
      AND a.time <= NEW.time
      AND a.time + (SELECT SUM(mp.estimate_time) FROM medical_procedure mp
                    JOIN procedure_appointment pa on mp.procedure_id = pa.procedure_id
                    WHERE mp.procedure_id = pa.procedure_id
                    AND pa.appointment_id = a.appointment_id) >= NEW.time
  );
  IF num_appointments != 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vet already has appointment at that time';
  END IF;
END //


CREATE TRIGGER check_vet_schedule_insert
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    DECLARE appointment_day_of_week INT;
    DECLARE day_of_week_to_char CHAR(3);
    DECLARE vets_employee_id INT;

    SET appointment_day_of_week = DAYOFWEEK(NEW.date);

    SET day_of_week_to_char = CASE
        WHEN appointment_day_of_week = 1 THEN 'Ndz'
        WHEN appointment_day_of_week = 2 THEN 'Pon'
        WHEN appointment_day_of_week = 3 THEN 'Wt'
        WHEN appointment_day_of_week = 4 THEN 'Śr'
        WHEN appointment_day_of_week = 5 THEN 'Czw'
        WHEN appointment_day_of_week = 6 THEN 'Pt'
        WHEN appointment_day_of_week = 7 THEN 'Sob'
    END;

    SELECT employee_id INTO vets_employee_id FROM vet WHERE vet.vet_id = NEW.vet_id;

    IF NOT EXISTS (
        SELECT * FROM employee_schedule es
        WHERE es.employee_id = vets_employee_id
        AND es.week_day = day_of_week_to_char
        AND NEW.time >= es.hour_start
        AND NEW.time < es.hour_end
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vet is not available at that time';
    END IF;
END //


CREATE TRIGGER check_vet_schedule_update
BEFORE UPDATE ON appointment
FOR EACH ROW
BEGIN
    DECLARE appointment_day_of_week INT;
    DECLARE day_of_week_to_char CHAR(3);
    DECLARE vets_employee_id INT;

    SET appointment_day_of_week = DAYOFWEEK(NEW.date);

    SET day_of_week_to_char = CASE
        WHEN appointment_day_of_week = 1 THEN 'Ndz'
        WHEN appointment_day_of_week = 2 THEN 'Pon'
        WHEN appointment_day_of_week = 3 THEN 'Wt'
        WHEN appointment_day_of_week = 4 THEN 'Śr'
        WHEN appointment_day_of_week = 5 THEN 'Czw'
        WHEN appointment_day_of_week = 6 THEN 'Pt'
        WHEN appointment_day_of_week = 7 THEN 'Sob'
    END;

    SELECT employee_id INTO vets_employee_id FROM vet WHERE vet.vet_id = NEW.vet_id;

    IF NOT EXISTS (
        SELECT * FROM employee_schedule es
        WHERE es.employee_id = vets_employee_id
        AND es.week_day = day_of_week_to_char
        AND NEW.time >= es.hour_start
        AND NEW.time < es.hour_end
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vet is not available at that time';
    END IF;
END //


CREATE TRIGGER check_salary_range_insert
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(7, 2);
    DECLARE max_salary DECIMAL(7, 2);

    SELECT salary_min, salary_max INTO min_salary, max_salary
    FROM position
    WHERE position_id = NEW.position_id;

    IF NEW.salary < min_salary OR NEW.salary > max_salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary is out of range defined to this position';
    END IF;
END //


CREATE TRIGGER check_salary_range_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(7, 2);
    DECLARE max_salary DECIMAL(7, 2);

    SELECT salary_min, salary_max INTO min_salary, max_salary
    FROM position
    WHERE position_id = NEW.position_id;

    IF NEW.salary < min_salary OR NEW.salary > max_salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary is out of range defined to this position';
    END IF;
END //


CREATE TRIGGER check_schedule_insert_conflict
BEFORE INSERT ON employee_schedule
FOR EACH ROW
BEGIN
    DECLARE existing_schedule INT;

    SET existing_schedule = (
        SELECT COUNT(*)
        FROM employee_schedule
        WHERE employee_id = NEW.employee_id
        AND week_day = NEW.week_day
    );

    IF existing_schedule > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Graphic conflict. This employee already has tasks scheduled for that day.';
    END IF;
END //


CREATE TRIGGER check_schedule_day_format
BEFORE INSERT ON employee_schedule
FOR EACH ROW
BEGIN
    IF NEW.week_day NOT IN ('Pon', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid weekday format. Give one of: Pon, Wt, Śr, Czw, Pt, Sob.';
    END IF;
END //


CREATE TRIGGER check_inventory_date
BEFORE INSERT ON inventory
FOR EACH ROW
    BEGIN
        IF NEW.best_before < CURDATE() THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add object past the expiration date';
        end if;
    end //

DELIMITER ;
