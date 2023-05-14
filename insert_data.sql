USE bd2_23l_z31;

-- 1 - Właściciele zwierząt
INSERT INTO owner (name, surname, address, phone_number, pesel) VALUES
    ('Jan', 'Kowalski', 'ul. Lipowa 5', '111222333', '12345678901'),
    ('Anna', 'Nowak', 'ul. Kwiatowa 10', '444555666', '98765432109'),
    ('Michał', 'Wiśniewski', 'ul. Parkowa 3', '777888999', '23456789012'),
    ('Katarzyna', 'Lis', 'ul. Słoneczna 5', '999888777', '34567890123'),
    ('Piotr', 'Wójcik', 'ul. Długa 7', '222333444', '45678901234'),
    ('Magdalena', 'Kaczmarek', 'ul. Radosna 12', '555666777', '56789012345'),
    ('Adam', 'Nowicki', 'ul. Cicha 8', '888999000', '67890123456'),
    ('Ewa', 'Krawczyk', 'ul. Jasna 14', '853434232', '78901234567'),
    ('Tomasz', 'Dudek', 'ul. Prosta 2', '742342943', '89012345678'),
    ('Małgorzata', 'Zając', 'ul. Zielona 1', '723812412', '90123456789'),
    ('Krzysztof', 'Sikora', 'ul. Łąkowa 9', '472812182', '01234567890'),
    ('Alicja', 'Grabowska', 'ul. Kwiatowa 20', '782923742', '12345678901'),
    ('Robert', 'Witkowski', 'ul. Miodowa 11', '718323864', '23456789012'),
    ('Dominika', 'Dąbrowska', 'ul. Słoneczna 6', '593323853', '34567890123'),
    ('Marcin', 'Kołodziej', 'ul. Parkowa 9', '539235382', '45678901234');

-- 2 - Zwierzęta
INSERT INTO animal (owner_id, name, species, type, gender, birthdate) VALUES
    (1, 'Burek', 'Pies', 'Mieszaniec', 'M', '2018-05-10'),
    (2, 'Mruczek', 'Kot', 'Syjamski', 'M', '2020-02-15'),
    (2, 'Lola', 'Kot', 'Brytyjski', 'F', '2019-09-01'),
    (3, 'Puszek', 'Kot', 'Perski', 'M', '2017-11-20'),
    (4, 'Azor', 'Pies', 'Labrador', 'M', '2015-07-08'),
    (5, 'Filemon', 'Kot', 'Europejski', 'M', '2021-03-12'),
    (6, 'Ruda', 'Kot', 'Mieszaniec', 'F', '2019-01-12'),
    (7, 'Bella', 'Pies', 'Golden Retriever', 'F', '2016-04-30'),
    (8, 'Mia', 'Kot', 'Maine Coon', 'F', '2020-11-05'),
    (8, 'Simba', 'Kot', 'Perski', 'M', '2018-08-20'),
    (9, 'Max', 'Pies', 'Husky', 'M', '2017-02-10'),
    (10, 'Molly', 'Kot', 'Ragdoll', 'F', '2019-06-25'),
    (11, 'Rocky', 'Pies', 'Owczarek niemiecki', 'M', '2014-10-15'),
    (12, 'Luna', 'Kot', 'Brytyjski krótkowłosy', 'F', '2020-03-18'),
    (13, 'Charlie', 'Pies', 'Border Collie', 'M', '2019-08-07'),
    (14, 'Lucy', 'Kot', 'Syjamski', 'F', '2017-12-03'),
    (15, 'Jack', 'Pies', 'Cocker Spaniel', 'M', '2016-05-22'),
    (15, 'Lily', 'Kot', 'Perski', 'F', '2018-09-09');

-- 3 - Choroby
INSERT INTO disease (name) VALUES
    ('Grypa'),
    ('Zapalenie oskrzeli'),
    ('Zapalenie ucha'),
    ('Zapalenie żołądka'),
    ('Alergia'),
    ('Kamienie nerkowe'),
    ('Zapalenie skóry'),
    ('Padaczka'),
    ('Cukrzyca'),
    ('Zapalenie stawów'),
    ('Problemy z tarczycą'),
    ('Kaszel kenelowy'),
    ('Wścieklizna'),
    ('Parwowiroza'),
    ('Leptospiroza');

-- 4 - Historia chorób
INSERT INTO disease_history (animal_id, disease_id, diagnosis_date, recovery_date, description) VALUES
    (1, 1, '2022-02-05', '2022-02-15', 'Pies miał gorączkę i kaszel.'),
    (2, 3, '2023-01-10', '2023-01-20', 'Kot miał zaczerwienione ucho i trudności z jedzeniem.'),
    (3, 5, '2021-11-18', '2021-11-25', 'Kot wykazywał reakcję alergiczną na pokarm.'),
    (4, 7, '2022-07-03', '2022-07-10', 'Kot miał swędzącą skórę i łysiejące miejsca.'),
    (5, 11, '2020-05-12', '2020-05-20', 'Pies miał trudności z oddychaniem i zmęczenie.'),
    (6, 13, '2021-09-08', '2021-09-15', 'Pies nie miał apetytu i gorączki.'),
    (8, 2, '2022-03-25', '2022-04-02', 'Kot miał kaszel i trudności z oddychaniem.'),
    (9, 4, '2023-04-12', '2023-04-20', 'Pies miał wymioty i biegunkę.'),
    (10, 6, '2021-07-02', '2021-07-10', 'Kot miał problemy z oddawaniem moczu.'),
    (12, 8, '2020-12-15', '2020-12-25', 'Pies miał napady padaczkowe.'),
    (13, 10, '2023-02-18', '2023-02-28', 'Kot miał opuchnięte i bolesne stawy.'),
    (14, 12, '2022-08-07', '2022-08-15', 'Kot miał problemy z tarczycą i trudności z oddychaniem.'),
    (15, 14, '2020-06-22', '2020-06-30', 'Pies miał drgawki i gorączkę.'),
    (1, 1, '2021-03-10', '2021-03-20', 'Pies miał gorączkę i bóle mięśni.');

-- 5 - Zabiegi
INSERT INTO medical_procedure (name, description, estimate_time) VALUES
    ('Badanie ogólne', 'Podstawowe badanie zdrowotne', '00:30:00'),
    ('Szczepienie', 'Podawanie szczepionki', '00:15:00'),
    ('Kastracja', 'Usunięcie gonad', '01:00:00'),
    ('Zdjęcie rentgenowskie', 'Diagnostyka obrazowa', '00:45:00'),
    ('USG', 'Badanie ultrasonograficzne', '00:45:00'),
    ('Zabieg chirurgiczny', 'Operacja', '02:00:00'),
    ('Wizyta kontrolna', 'Kontrola po leczeniu', '00:30:00'),
    ('Pobranie próbki krwi', 'Diagnostyka laboratoryjna', '00:15:00'),
    ('Oczyszczenie uszu', 'Usuwanie woskowiny z uszu', '00:20:00'),
    ('Stomatologia', 'Zabiegi związane z zębami', '01:30:00'),
    ('Zakładanie opatrunku', 'Zabezpieczanie ran i skaleczeń', '00:20:00'),
    ('Znieczulenie', 'Podawanie środka znieczulającego', '00:30:00'),
    ('Eutanazja', 'Łagodne uśpienie zwierzęcia', '00:15:00'),
    ('Rehabilitacja', 'Ćwiczenia i terapia dla zwierząt', '01:30:00'),
    ('Zabieg dentystyczny', 'Zabiegi związane z zębami', '01:00:00'),
    ('Badanie serca', 'Badanie elektrokardiograficzne', '00:45:00'),
    ('Zabieg dermatologiczny', 'Zabiegi związane ze skórą', '01:15:00'),
    ('Zabieg oczny', 'Zabiegi związane z oczami', '01:30:00'),
    ('Diagnostyka laboratoryjna', 'Badanie laboratoryjne', '01:00:00'),
    ('Zabieg ortopedyczny', 'Zabiegi związane z kośćmi i stawami', '02:30:00'),
    ('Zabieg kardiologiczny', 'Zabiegi związane z sercem', '02:00:00'),
    ('Zabieg neurologiczny', 'Zabiegi związane z układem nerwowym', '02:15:00'),
    ('Zabieg onkologiczny', 'Zabiegi związane z nowotworami', '03:00:00');

-- 6 - Stanowiska
INSERT INTO position (name, description, salary_min, salary_max) VALUES
    ('Recepcjonista', 'Obsługa recepcji i rejestracja pacjentów', 2000.00, 3000.00),
    ('Asystent weterynarza', 'Pomoc przy zabiegach i badaniach', 2500.00, 3500.00),
    ('Higienistka', 'Czyszczenie i dezynfekcja pomieszczeń', 1800.00, 2200.00),
    ('Kierownik kliniki', 'Zarządzanie kliniką i personelem', 4000.00, 6000.00);

-- 7 - Pracownicy
INSERT INTO employee (position_id, name, surname, phone_number, address, salary, employment_date, bonus) VALUES
    (1, 'Jan', 'Kowalski', '123456789', 'ul. Przykładowa 1, Warszawa', 2500.00, '2020-01-15', 500.00),
    (2, 'Anna', 'Nowak', '987654321', 'ul. Testowa 2, Kraków', 2800.00, '2021-05-10', 300.00),
    (3, 'Piotr', 'Wiśniewski', '567891234', 'ul. Modelowa 3, Gdańsk', 2200.00, '2019-08-20', 400.00),
    (2, 'Maria', 'Lewandowska', '345678912', 'ul. Próbna 4, Wrocław', 3000.00, '2022-02-28', 600.00),
    (1, 'Andrzej', 'Dąbrowski', '789123456', 'ul. Lekarska 5, Łódź', 2700.00, '2020-11-05', 200.00),
    (4, 'Magdalena', 'Jankowska', '234567891', 'ul. Miodowa 6, Poznań', 5000.00, '2018-04-12', 800.00),
    (3, 'Krzysztof', 'Wójcik', '912345678', 'ul. Długa 7, Katowice', 2400.00, '2021-09-15', 400.00),
    (4, 'Barbara', 'Kamińska', '876543219', 'ul. Krótka 8, Lublin', 5500.00, '2017-07-22', 1000.00),
    (1, 'Tomasz', 'Kowalczyk', '654321987', 'ul. Ciasna 9, Szczecin', 2900.00, '2022-06-10', 300.00),
    (2, 'Alicja', 'Zielińska', '219876543', 'ul. Testowa 10, Białystok', 3200.00, '2019-03-28', 500.00);

-- 8 - Weterynarze
INSERT INTO vet (employee_id, specialization) VALUES
    (2, 'Chirurgia'),
    (4, 'Dermatologia'),
    (6, 'Kardiologia'),
    (8, 'Neurologia');

-- 9 - Sale
INSERT INTO room (room_number) VALUES
    ('101'),
    ('102'),
    ('103'),
    ('201'),
    ('202'),
    ('203');

-- 10 - Wizyty
INSERT INTO appointment (procedure_id, vet_id, room_id, animal_id, date, time) VALUES
    (1, 2, 1, 1, '2023-01-15', '10:00:00'),
    (3, 4, 2, 2, '2023-02-10', '14:30:00'),
    (2, 2, 1, 3, '2023-03-05', '11:45:00'),
    (6, 1, 3, 4, '2023-04-20', '09:15:00'),
    (4, 4, 2, 5, '2023-05-18', '16:30:00'),
    (5, 1, 3, 6, '2023-06-22', '13:00:00'),
    (7, 2, 1, 7, '2023-07-12', '10:45:00'),
    (9, 1, 3, 8, '2023-08-05', '15:30:00'),
    (8, 3, 2, 9, '2023-09-28', '12:15:00'),
    (10, 3, 3, 10, '2023-10-17', '11:00:00');

-- 11 - Zabieg-Wizyta (przechodnia)
INSERT INTO procedure_appointment (appointment_id, procedure_id) VALUES
    (1, 1),
    (2, 3),
    (3, 2),
    (4, 6),
    (5, 4),
    (6, 5),
    (7, 7),
    (8, 9),
    (9, 8),
    (10, 10);

-- 12- Harmonogram pracowników
INSERT INTO employee_schedule (employee_id, week_day, hour_start, hour_end) VALUES
    (2, 'Pn', '09:00:00', '17:00:00'),
    (2, 'Wt', '09:00:00', '17:00:00'),
    (2, 'Śr', '09:00:00', '13:00:00'),
    (2, 'Cz', '09:00:00', '17:00:00'),
    (3, 'Pn', '12:00:00', '18:00:00'),
    (3, 'Cz', '12:00:00', '18:00:00'),
    (3, 'Śr', '12:00:00', '18:00:00'),
    (3, 'Cz', '12:00:00', '18:00:00');

-- 13 - Metody płatności
INSERT INTO payment_method (name) VALUES
    ('Gotówka'),
    ('Karta płatnicza'),
    ('BLIK'),
    ('Voucher');

-- 14 - Opłaty za wizyty
INSERT INTO payment (appointment_id, method_id, amount, date_paid) VALUES
    (1, 1, 150.00, '2023-01-16 10:30:00'),
    (2, 2, 75.50, '2023-02-11 15:20:00'),
    (4, 3, 120.00, '2023-03-06 12:45:00'),
    (4, 1, 200.00, '2023-04-21 09:40:00'),
    (5, 2, 85.75, '2023-05-19 17:15:00'),
    (6, 3, 180.00, '2023-06-23 13:50:00'),
    (7, 1, 100.00, '2023-07-13 11:10:00'),
    (8, 2, 150.25, '2023-08-06 16:25:00'),
    (9, 3, 220.50, '2023-09-29 14:30:00'),
    (10, 1, 80.00, '2023-10-18 11:55:00');

INSERT INTO examination (animal_id, vet_id, date, result) VALUES
    (1, 2, '2023-01-18', 'Wyniki badań są zadowalające.'),
    (2, 4, '2023-02-12', 'Wykryto alergię na pyłki.'),
    (3, 2, '2023-03-07', 'Zalecana dalsza obserwacja.'),
    (4, 1, '2023-04-22', 'Wyniki badań serca są prawidłowe.'),
    (5, 4, '2023-05-20', 'Zalecana zmiana diety.'),
    (6, 1, '2023-06-24', 'Wyniki badania neurologicznego są prawidłowe.'),
    (7, 2, '2023-07-14', 'Zalecana szczepionka przeciwko wściekliźnie.'),
    (8, 1, '2023-08-07', 'Wykryto niewielkie zmiany na skórze.'),
    (9, 3, '2023-09-30', 'Zalecana rehabilitacja ruchowa.'),
    (10, 3, '2023-10-19', 'Wyniki badania krwi są prawidłowe.');

-- 16 - Jednostki miary
INSERT INTO unit_of_measure (name, short) VALUES
    ('Mililitr', 'ml'),
    ('Gram', 'g'),
    ('Sztuka', 'szt'),
    ('Opakowanie', 'opk');

-- 17 - Inwentarz
INSERT INTO inventory (unit_id, name, amount, best_before) VALUES
    (1, 'Karma sucha', 50.00, '2024-01-01'),
    (2, 'Szampon', 200.00, '2023-12-31'),
    (3, 'Antybiotyk', 100.50, '2024-06-30'),
    (2, 'Odżywka', 150.00, '2023-10-15'),
    (3, 'Probiotyk', 75.25, '2024-02-28'),
    (1, 'Kołnierz ochronny', 30.00, '2023-11-30'),
    (2, 'Karma mokra', 80.00, '2023-12-15'),
    (3, 'Przeciwpchelny preparat', 90.50, '2023-09-30'),
    (1, 'Karma dietetyczna', 60.75, '2024-03-31'),
    (2, 'Szczotka do zębów', 25.00, '2023-11-15'),
    (3, 'Witaminy', 120.25, '2024-05-31'),
    (1, 'Obroża przeciwkleszczowa', 40.00, '2023-09-15'),
    (2, 'Miska ceramiczna', 35.50, '2023-12-31'),
    (3, 'Karma dla szczeniąt', 70.25, '2024-04-30');

-- 18 - Sprzęt medyczny
INSERT INTO medical_equipment (name, description) VALUES
    ('Aparat EKG', 'Przyrząd do badania pracy serca'),
    ('Lampa otoskopowa', 'Przyrząd do badania uszu'),
    ('Stetoskop', 'Do badania słuchu i tętna.'),
    ('Termometr', 'Do mierzenia temperatury.'),
    ('Skalpel', 'Do wykonywania precyzyjnych cięć.'),
    ('Mikroskop', 'Do badania próbek mikroskopowych.'),
    ('Rentgen', 'Do wykonywania zdjęć rentgenowskich.'),
    ('Elektrokardiograf', 'Do badania pracy serca.'),
    ('Endoskop', 'Do badania wnętrza ciała przez drogi naturalne.');

-- 19 - Sala-Sprzęt medyczny (przechodnia)
INSERT INTO room_medical_equipment (equipment_id, room_id, last_inspection, next_inspection) VALUES
    (1, 1, '2023-01-05', '2024-01-05'),
    (2, 2, '2023-02-01', '2024-02-01'),
    (3, 3, '2023-03-10', '2024-03-10'),
    (4, 1, '2023-04-15', '2024-04-15'),
    (5, 2, '2023-05-12', '2024-05-12'),
    (6, 3, '2023-06-20', '2024-06-20'),
    (7, 1, '2023-07-25', '2024-07-25'),
    (1, 2, '2023-08-22', '2024-08-22'),
    (2, 3, '2023-09-30', '2024-09-30'),
    (3, 1, '2023-10-25', '2024-10-25'),
    (4, 2, '2023-11-28', '2024-11-28'),
    (5, 3, '2023-12-15', '2024-12-15'),
    (6, 1, '2024-01-10', '2025-01-10'),
    (7, 2, '2024-02-18', '2025-02-18');