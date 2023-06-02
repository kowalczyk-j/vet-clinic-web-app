# MODUŁ WIZYT

# nie da się umówić wizyty, jeśli lekarz jest w danym terminie zajęty
INSERT INTO appointment VALUE (31, 3, 1, 9, '2023-07-25', '16:30:00');
INSERT INTO procedure_appointment VALUE (31, 1);
INSERT INTO appointment (vet_id, room_id, animal_id, date, time) VALUE (3, 2, 11, '2023-07-25', '16:30:00');

# usunięcie wizyty usuwa dane powiązane z tą wizytą z tabel payment oraz procedure_appointment
INSERT INTO payment (appointment_id, method_id, amount, date_paid) VALUE (31, 1, 100.00, '2020-11-25 15:45:00');
DELETE FROM appointment WHERE appointment_id = 31;

# nie da się umówić wizyty w przeszłości
INSERT INTO appointment (vet_id, room_id, animal_id, date, time) VALUE (3, 1, 8, '2020-11-25', '16:30:00');

# nie da się przełożyć wizyty na datę w przeszłości
UPDATE appointment SET date = '2022-07-10' WHERE appointment_id = 30;

# umówiona wizyta musi być w trakcie pracy lekarza (zgodnie z harmonogramem employee_schedule)
INSERT INTO appointment (vet_id, room_id, animal_id, date, time) VALUE (1, 1, 3, '2023-06-05', '16:30:00');

# przełożona wizyta musi być w trakcie pracy lekarza (zgodnie z harmonogramem employee_schedule)
UPDATE appointment SET date = '2023-06-06', time = '20:00:00' WHERE appointment_id = 30;

# to samo zwierzę nie może mieć dwóch wizyt na raz
INSERT INTO appointment (vet_id, room_id, animal_id, date, time) VALUE (1, 1, 3, '2023-06-06', '18:00:00');
INSERT INTO appointment (vet_id, room_id, animal_id, date, time) VALUE (2, 1, 3, '2023-06-06', '18:00:00');

# MODUŁ PERSONELU + GRAFIK

# nie da się dodać pracownika o nieistniejącym stanowisku
INSERT INTO employee (position_id, name, surname, phone_number, address, salary, employment_date)
VALUES (11, 'Jan', 'Kowalski', '742245234', 'ul. Testowa 1', 5000, '2023-06-01');

# numery telefonów każdego z pracowników muszą się różnić
INSERT INTO employee (position_id, name, surname, phone_number, address, salary, employment_date)
VALUES (1, 'Jan', 'Kowalski', '123456789', 'ul. Testowa 1', 5000, '2023-06-01');

# nie da się dodać daty zatrudnienia w przyszłości
INSERT INTO employee (position_id, name, surname, phone_number, address, salary, employment_date)
VALUES (1, 'Jan', 'Kowalski', '232456789', 'ul. Testowa 1', 5000, '2024-06-01');

# jeżeli data zatrudnienia nie została podana, ustawiana jest jako dzisiejsza
INSERT INTO employee (position_id, name, surname, phone_number, address, salary)
VALUES (1, 'Jan', 'Kowalski', '232456581', 'ul. Testowa 1', 5000);
SELECT employment_date FROM employee WHERE phone_number = '232456581';

# nie da się ustawić zarobków, które nie mieszczą się w przedziale min_salary i max_salary dla danego stanowiska
INSERT INTO employee (position_id, name, surname, phone_number, address, salary, employment_date)
VALUES (1, 'Jan', 'Kowalski', '743812924', 'ul. Testowa 1', 10000, '2023-06-01');
UPDATE employee SET salary = 101 WHERE employee_id = 1;

# rekord w grafiku musi posiadać dzień w odpowiednim formacie (Pon, Wt, Śr, Czw, Pt, Sob)
INSERT INTO employee_schedule (employee_id, week_day, hour_start, hour_end)
VALUES (1, 'ŚRD', '10:00', '12:00');

# nie da się dodać rekordu w grafiku dla pracownika, który w danym dniu już ma zdefiniowane godziny pracy
INSERT INTO employee_schedule (employee_id, week_day, hour_start, hour_end)
VALUES (1, 'Pon', '10:00', '12:00');

# harmonogram umożliwia sprawdzenie dostępności konkretnego pracownika w danym dniu i godzinie
SELECT *
FROM employee_schedule
WHERE employee_id = 1
AND week_day = 'Pon'
AND '12:00:00' BETWEEN hour_start AND hour_end;

# harmonogram umożliwia wygenerowanie godzin pracy wszystkich pracowników na danym stanowisku i danego dnia
SELECT e.employee_id, e.name, e.surname, es.week_day, es.hour_start, es.hour_end, p.name
FROM employee e
JOIN employee_schedule es ON e.employee_id = es.employee_id
JOIN position p on e.position_id = p.position_id
WHERE p.name = 'Recepcjonista'
AND es.week_day = 'Pon'
ORDER BY es.hour_start;

# MODUŁ ZARZĄDZANIA PACJENTAMI

# Dodanie nowego właściciela
INSERT INTO owner (name, surname, address, phone_number, pesel)
VALUES ('Jan', 'Kowalski', 'ul. Testowa 1', '111222333', '12345678901');

# Dodanie nowego zwierzęcia
INSERT INTO animal (owner_id, name, species, type, gender, birthdate)
VALUES (LAST_INSERT_ID(), 'Burek', 'Pies', 'Owczarek Niemiecki', 'M', '2018-05-10');

# Dodanie zwierzęcia z błędną datą urodzenia
INSERT INTO animal (owner_id, name, species, type, gender, birthdate)
VALUES (LAST_INSERT_ID(), 'Burek', 'Pies', 'Owczarek Niemiecki', 'M', '2024-02-01');

# Dodanie właściciela z błędnym numerem telefonu
INSERT INTO owner (name, surname, address, phone_number, pesel)
VALUES ('Jan', 'Kowalski', 'ul. Testowa 1', 'telefon', '12345678901');

# Dodanie zwierzęcia z błędnym włascicielem
INSERT INTO animal (owner_id, name, species, type, gender, birthdate)
VALUES (-10000, 'Burek', 'Pies', 'Owczarek Niemiecki', 'M', '2024-02-01');

# Dodanie historii chorób dla danego pacjenta
INSERT INTO disease_history (animal_id, disease_id, diagnosis_date, recovery_date, description)
VALUES (1, 1, '2022-02-05', '2022-02-15', 'Pies miał problemy z oddychaniem.');

# Zmiana danych właściciela
UPDATE owner
SET name = 'Adam', surname = 'Nowak', phone_number = '987654321', address = 'ul. Nowa 2', pesel = '12345678911'
WHERE owner_id = 1;

# Zmiana danych zwierzęcia
UPDATE animal
SET name = 'Azor', type = 'Labrador Retriever'
WHERE animal_id = 1;

# Generowanie raportu o najczęstszych chorobach:
SELECT d.name AS disease, COUNT(*) AS occurrences
FROM disease_history dh
JOIN disease d ON dh.disease_id = d.disease_id
GROUP BY d.name
ORDER BY occurrences DESC;

# Generowanie raportu o zabiegach
SELECT p.name AS procedure, COUNT(*) AS performed
FROM procedure_appointment pa
JOIN procedure p ON pa.procedure_id = p.procedure_id
GROUP BY procedure
ORDER BY performed DESC;

# MODUŁ INWENTARZU

# Dodanie obiektu o błednej ilości
INSERT INTO inventory (unit_id, name, amount, best_before) VALUES
(2, 'Karma sucha', -6000.00, '2024-01-01');

# Dodanie powtarzającego się obiektu
INSERT INTO inventory (unit_id, name, amount, best_before) VALUES
(2, 'Karma sucha', 3000.00, '2024-01-01');
SELECT amount FROM inventory
WHERE name = 'Karma sucha';

INSERT INTO inventory (unit_id, name, amount, best_before) VALUES
(2, 'Karma sucha', 3500.00, '2024-01-01');
SELECT amount FROM inventory
WHERE name = 'Karma sucha';

# Dodanie obiektu o błędnej dacie przeterminowania
INSERT INTO inventory (unit_id, name, amount, best_before) VALUES
(2, 'Karma mokra', 2000.00, '2019-01-01');
