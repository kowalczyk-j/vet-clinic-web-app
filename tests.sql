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
