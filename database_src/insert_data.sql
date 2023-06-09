USE bd2_23l_z31;

-- 1 - Właściciele zwierząt
INSERT INTO owner (name, surname, address, phone_number, pesel) VALUES
    ('Jan', 'Kowalski', 'ul. Lipowa 5, 00-631 Warszawa', '111222333', '12345678901'),
    ('Anna', 'Nowak', 'ul. Kwiatowa 10/12, 00-631 Warszawa', '444555666', '98765432109'),
    ('Michał', 'Wiśniewski', 'ul. Parkowa 3/11, 00-631 Warszawa', '777888999', '23456789012'),
    ('Katarzyna', 'Lis', 'ul. Słoneczna 5/10, 00-631 Warszawa', '999888777', '34567890123'),
    ('Piotr', 'Wójcik', 'ul. Długa 7/6, 00-631 Warszawa', '222333444', '45678901234'),
    ('Magdalena', 'Kaczmarek', 'ul. Radosna 12/50a, 00-636 Warszawa', '555666777', '56789012345'),
    ('Adam', 'Nowicki', 'ul. Cicha 8/2, 42-112 Kraków', '888999000', '67890123456'),
    ('Ewa', 'Krawczyk', 'ul. Jasna 14/3, 00-686 Warszawa', '853434232', '78901234567'),
    ('Tomasz', 'Dudek', 'ul. Prosta 2, 00-631 Warszawa', '742342943', '89012345678'),
    ('Małgorzata', 'Zając', 'ul. Zielona 1, 00-612 Warszawa', '723812412', '90123456789'),
    ('Krzysztof', 'Sikora', 'ul. Łąkowa 9, 00-631 Warszawa', '472812182', '01234567890'),
    ('Alicja', 'Grabowska', 'ul. Kwiatowa 20/12, 00-644 Warszawa', '782923742', '12345678902'),
    ('Robert', 'Witkowski', 'ul. Miodowa 11, 00-631 Warszawa', '718323864', '23456789042'),
    ('Dominika', 'Dąbrowska', 'ul. Słoneczna 6/21c, 00-631 Warszawa', '593323853', '34567890125'),
    ('Marcin', 'Kołodziej', 'ul. Parkowa 9/603, 12-200 Pisz', '539235382', '45678901224');

-- 2 - Zwierzęta
INSERT INTO animal (owner_id, name, species, type, gender, birthdate) VALUES
    (1, 'Burek', 'Pies', 'Mieszaniec', 'M', '2018-05-10'),
    (2, 'Mruczek', 'Kot', 'Syjamski', 'M', '2020-02-15'),
    (2, 'Lola', 'Kot', 'Brytyjski', 'F', '2019-09-01'),
    (3, 'Puszek', 'Kot', 'Perski', 'M', '2017-11-20'),
    (4, 'Azor', 'Pies', 'Labrador', 'M', '2015-07-08'),
    (5, 'Filemon', 'Kot', 'Europejski', 'M', '2021-03-12'),
    (6, 'Ruda', 'Kot', 'Mieszaniec', 'F', '2019-01-12'),
    (7, 'Bella', 'Szynszyla', 'Ebony', 'F', '2021-04-30'),
    (8, 'Mia', 'Kot', 'Maine Coon', 'F', '2020-11-05'),
    (8, 'Simba', 'Kot', 'Perski', 'M', '2018-08-20'),
    (9, 'Max', 'Pies', 'Husky', 'M', '2017-02-10'),
    (10, 'Molly', 'Kot', 'Ragdoll', 'F', '2019-06-25'),
    (11, 'Rocky', 'Pies', 'Owczarek niemiecki', 'M', '2014-10-15'),
    (12, 'Luna', 'Kot', 'Brytyjski krótkowłosy', 'F', '2020-03-18'),
    (13, 'Charlie', 'Pies', 'Border Collie', 'M', '2019-08-07'),
    (14, 'Lucy', 'Chomik', 'Dżungarski', 'F', '2022-12-03'),
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
    ('Leptospiroza'),
    ('Zapalenie dziąseł'),
    ('Złamanie zęba'),
    ('Infekcja zębopochodna'),
    ('Inne');

-- 4 - Historia chorób
INSERT INTO disease_history (animal_id, disease_id, diagnosis_date, recovery_date, description) VALUES
    (1, 1, '2022-02-05', '2022-02-15', 'Pies miał gorączkę i kaszel.'),
    (2, 3, '2023-01-10', '2023-01-20', 'Kot miał zaczerwienione ucho i trudności z jedzeniem.'),
    (3, 5, '2021-11-18', '2021-11-25', 'Kot wykazywał reakcję alergiczną na pokarm.'),
    (4, 7, '2022-07-03', '2022-07-10', 'Kot miał swędzącą skórę i łysiejące miejsca.'),
    (5, 11, '2020-05-12', '2020-05-20', 'Pies miał trudności z oddychaniem i zmęczenie.'),
    (6, 13, '2021-09-08', '2021-09-15', 'Kot nie miał apetytu i nadmiernie się ślinił.'),
    (7, 12, '2021-09-08', '2021-09-15', 'Kot kaszlał kilkukrotnie w ciągu godziny.'),
    (8, 16, '2022-03-25', '2022-04-02', 'Szynszyla miała uszkodzone uzębienie.'),
    (9, 4, '2023-04-12', '2023-04-20', 'Kot miał wymioty i biegunkę.'),
    (10, 6, '2021-07-02', '2021-07-10', 'Kot miał problemy z oddawaniem moczu.'),
    (12, 8, '2020-12-15', '2020-12-25', 'Pies miał napady padaczkowe.'),
    (13, 10, '2023-02-18', '2023-02-28', 'Kot miał opuchnięte i bolesne stawy.'),
    (14, 12, '2022-08-07', '2022-08-15', 'Pies miał problemy z tarczycą i trudności z oddychaniem.'),
    (15, 14, '2020-06-22', '2020-06-30', 'Kot miał drgawki i gorączkę.'),
    (16, 1, '2021-03-10', '2021-03-20', 'Pies miał gorączkę i bóle mięśni.'),
    (17, 19, '2021-09-08', '2021-09-15', 'Chomik był otępiały i nie przyjmował pokarmu.'),
    (18, 9, '2021-09-08', '2021-09-15', 'Pies robił się senny po przyjęciu karmy.'),
    (2, 18, '2021-09-08', '2021-09-15', 'Kot krwawił z ust.'),
    (1, 1, '2023-05-08', '2021-09-15', 'Pies ponownie dostał gorączki.');

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
    ('Znieczulenie', 'Podawanie środka znieczulającego', '00:10:00'),
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
    ('Zabieg onkologiczny', 'Zabiegi związane z nowotworami', '03:00:00'),
    ('Inne', 'Zabiegi szczególnego przypadku', '01:00:00');

-- 6 - Stanowiska
INSERT INTO position (name, description, salary_min, salary_max) VALUES
    ('Recepcjonista', 'Obsługa recepcji i rejestracja pacjentów', 4000.00, 6000.00),
    ('Asystent weterynarza', 'Pomoc przy zabiegach i badaniach', 4000.00, 7500.00),
    ('Serwis sprzątający', 'Czyszczenie i dezynfekcja pomieszczeń', 3000.00, 5000.00),
    ('Menedżer kliniki', 'Zarządzanie kliniką i personelem', 5000.00, 15000.00),
    ('Weterynarz', 'Leczenie i opieka nad zwięrzętami', 5000.00, 20000.00);

-- 7 - Pracownicy
INSERT INTO employee (position_id, name, surname, phone_number, address, salary, employment_date, bonus) VALUES
    (1, 'Jan', 'Kowalski', '123456789', 'ul. Przykładowa 1, 00-631 Warszawa', 4200.00, '2020-01-15', 100.00),
    (5, 'Anna', 'Nowak', '987654321', 'ul. Testowa 2, 00-631 Warszawa', 6800.00, '2021-05-10', 300.00),
    (2, 'Piotr', 'Wiśniewski', '567891234', 'ul. Modelowa 3, 00-611 Warszawa', 4200.00, '2019-08-20', 400.00),
    (5, 'Maria', 'Lewandowska', '345678912', 'ul. Próbna 4, 00-661 Warszawa', 7000.00, '2022-02-28', 600.00),
    (4, 'Andrzej', 'Dąbrowski', '789123456', 'ul. Lekarska 5, 00-621 Warszawa', 12000.00, '2020-11-05', 200.00),
    (5, 'Magdalena', 'Jankowska', '234567891', 'ul. Miodowa 6, 00-631 Warszawa', 6200.00, '2018-04-12', 800.00),
    (3, 'Krzysztof', 'Wójcik', '912345678', 'ul. Długa 7, 00-634 Warszawa', 3400.00, '2021-09-15', 400.00),
    (5, 'Barbara', 'Kamińska', '876543219', 'ul. Krótka 8, 21-631 Legionowo', 5500.00, '2017-07-22', 1000.00),
    (5, 'Tomasz', 'Kowalczyk', '654321987', 'ul. Ciasna 9, 00-631 Warszawa', 16000.00, '2022-06-10', 300.00),
    (1, 'Alicja', 'Zielińska', '219876543', 'ul. Testowa 10, 00-631 Warszawa', 4200.00, '2019-03-28', 500.00);

-- 8 - Weterynarze
INSERT INTO vet (employee_id, specialization) VALUES
    (2, 'Chirurgia'),
    (4, 'Dermatologia'),
    (6, 'Kardiologia'),
    (8, 'Diagnostyka obrazowa'),
    (9, 'Stomatologia');

-- 9 - Sale
INSERT INTO room (room_number, type) VALUES
    ('101', 'Podstawowy pokój kontrolny' ),
    ('102', 'Sala zabiegowa dla zwierząt egzotycznych'),
    ('103', 'Sala diagnostyki obrazowej RTG'),
    ('201', 'Sala operacyjna dla zwierząt domowych'),
    ('202', 'Sala stomatologiczno-higieniczna');

-- 10 - Harmonogram pracowników
INSERT INTO employee_schedule (employee_id, week_day, hour_start, hour_end) VALUES
    (1, 'Pon', '11:00', '19:00'),
    (1, 'Wt', '11:00', '19:00'),
    (1, 'Śr', '11:00', '19:00'),
    (2, 'Wt', '11:00', '19:00'),
    (2, 'Śr', '11:00', '19:00'),
    (2, 'Sob', '11:00', '19:00'),
    (3, 'Pon', '11:00', '19:00'),
    (3, 'Wt', '11:00', '19:00'),
    (3, 'Śr', '11:00', '19:00'),
    (3, 'Czw', '11:00', '19:00'),
    (3, 'Pt', '11:00', '19:00'),
    (3, 'Sob', '11:00', '19:00'),
    (4, 'Pt', '11:00', '19:00'),
    (4, 'Sob', '11:00', '19:00'),
    (5, 'Pon', '11:00', '19:00'),
    (5, 'Wt', '11:00', '19:00'),
    (5, 'Śr', '11:00', '19:00'),
    (5, 'Czw', '11:00', '19:00'),
    (5, 'Pt', '11:00', '19:00'),
    (5, 'Sob', '11:00', '19:00'),
    (6, 'Pon', '11:00', '19:00'),
    (6, 'Wt', '11:00', '19:00'),
    (6, 'Czw', '11:00', '19:00'),
    (7, 'Pon', '11:00', '15:00'),
    (7, 'Wt', '15:00', '19:00'),
    (7, 'Śr', '11:00', '15:00'),
    (7, 'Czw', '11:00', '19:00'),
    (7, 'Pt', '12:00', '15:00'),
    (7, 'Sob', '17:00', '19:00'),
    (8, 'Pon', '13:00', '19:00'),
    (8, 'Wt', '15:00', '19:00'),
    (9, 'Wt', '13:00', '19:00'),
    (9, 'Czw', '13:00', '19:00'),
    (9, 'Pt', '17:00', '19:00'),
    (9, 'Sob', '12:00', '19:00'),
    (10, 'Czw', '11:00', '19:00'),
    (10, 'Pt', '11:00', '19:00'),
    (10, 'Sob', '11:00', '19:00');

-- 11 - Wizyty
INSERT INTO appointment (vet_id, room_id, animal_id, date, time) VALUES
    (2, 1, 1, '2023-06-16', '11:30:00'),
    (4, 2, 2, '2023-07-10', '13:30:00'),
    (2, 1, 3, '2023-06-03', '15:45:00'),
    (1, 3, 4, '2023-06-20', '13:15:00'),
    (4, 2, 5, '2023-08-15', '16:00:00'),
    (1, 3, 6, '2023-07-22', '14:30:00'),
    (2, 1, 7, '2023-06-10', '11:45:00'),
    (5, 3, 8, '2023-06-06', '17:30:00'),
    (3, 2, 9, '2023-07-27', '12:15:00'),
    (3, 3, 10, '2023-06-13', '11:00:00'),
    (2, 1, 11, '2024-02-10', '14:00:00'),
    (4, 2, 12, '2023-06-05', '16:45:00'),
    (2, 1, 13, '2023-06-16', '14:30:00'),
    (1, 3, 14, '2023-06-21', '12:15:00'),
    (4, 2, 15, '2023-06-06', '16:30:00'),
    (1, 3, 16, '2023-07-05', '15:45:00'),
    (2, 4, 17, '2023-07-21', '14:30:00'),
    (1, 3, 18, '2023-08-09', '16:15:00'),
    (3, 2, 1, '2023-07-27', '12:30:00'),
    (3, 3, 2, '2023-07-13', '14:00:00'),
    (2, 1, 5, '2023-06-30', '11:45:00'),
    (4, 2, 6, '2023-06-12', '16:30:00'),
    (2, 1, 8, '2023-06-30', '13:30:00'),
    (1, 3, 1, '2023-08-05', '17:00:00'),
    (4, 2, 16, '2023-06-19', '13:00:00'),
    (1, 3, 12, '2024-02-24', '14:15:00'),
    (2, 5, 13, '2023-06-10', '15:30:00'),
    (5, 4, 15, '2023-07-13', '18:00:00'),
    (3, 2, 11, '2023-12-19', '12:00:00'),
    (3, 3, 2, '2023-11-23', '16:30:00');

-- 12 - Zabieg-Wizyta (przechodnia)
INSERT INTO procedure_appointment (appointment_id, procedure_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (3, 21),
    (4, 4),
    (5, 5),
    (6, 6),
    (6, 13),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10),
    (10, 21),
    (11, 11),
    (12, 12),
    (13, 13),
    (14, 14),
    (15, 15),
    (16, 16),
    (17, 17),
    (18, 18),
    (19, 19),
    (20, 20),
    (21, 21),
    (22, 22),
    (23, 23),
    (24, 24),
    (25, 12),
    (26, 14),
    (27, 16),
    (28, 20),
    (29, 1),
    (30, 2);

-- 13 - Metody płatności
INSERT INTO payment_method (name) VALUES
    ('Gotówka'),
    ('Karta płatnicza'),
    ('BLIK'),
    ('Voucher');

-- 14 - Opłaty za wizyty
INSERT INTO payment (appointment_id, method_id, amount, date_paid) VALUES
    (1, 1, 250.00, '2022-12-15 15:30:00'),
    (2, 2, 580.00, '2022-11-10 16:00:00'),
    (3, 1, 335.00, '2022-10-05 18:30:00'),
    (4, 2, 260.00, '2022-09-20 14:30:00'),
    (5, 1, 45.00, '2022-08-18 17:45:00'),
    (6, 2, 55.00, '2022-07-22 15:15:00'),
    (7, 1, 340.00, '2022-06-12 12:30:00'),
    (8, 2, 470.00, '2022-05-05 20:00:00'),
    (9, 1, 225.00, '2022-04-28 13:45:00'),
    (10, 2, 390.00, '2022-03-17 12:30:00'),
    (11, 1, 650.00, '2022-02-10 15:30:00'),
    (12, 4, 880.00, '2022-01-05 17:00:00'),
    (13, 1, 435.00, '2021-12-15 12:30:00'),
    (14, 2, 160.00, '2021-11-22 13:15:00'),
    (15, 1, 545.00, '2021-10-30 14:30:00'),
    (16, 2, 255.00, '2021-10-05 16:45:00'),
    (17, 3, 340.00, '2021-09-20 15:30:00'),
    (18, 2, 770.00, '2021-08-10 18:15:00'),
    (19, 1, 256.00, '2021-07-28 13:30:00'),
    (20, 3, 940.00, '2021-07-15 15:00:00'),
    (21, 1, 540.00, '2021-06-30 16:15:00'),
    (22, 2, 807.00, '2021-06-10 17:45:00'),
    (23, 1, 335.00, '2021-05-20 14:45:00'),
    (24, 2, 630.00, '2021-04-05 18:30:00'),
    (25, 1, 455.00, '2021-03-15 13:45:00'),
    (26, 2, 525.00, '2021-02-25 15:15:00'),
    (27, 3, 40.00, '2021-02-05 17:30:00'),
    (28, 2, 70.00, '2021-01-12 20:15:00'),
    (29, 1, 225.00, '2020-12-18 13:30:00'),
    (30, 2, 90.00, '2020-11-25 15:45:00');

-- 15 - Wyniki badań
INSERT INTO examination (animal_id, vet_id, date, result) VALUES
    (1, 1, '2022-12-18', 'Badanie krwi - wyniki są zadowalające.'),
    (2, 4, '2022-11-12', 'Badanie alergiczne - wykryto alergię na pyłki.'),
    (3, 2, '2022-10-07', 'Badanie ogólne - zalecana dalsza obserwacja.'),
    (4, 1, '2022-09-22', 'Badanie serca - wyniki są prawidłowe.'),
    (5, 5, '2022-08-20', 'Badanie żywieniowe - zalecana zmiana diety.'),
    (6, 1, '2022-07-24', 'Badanie neurologiczne - wyniki są prawidłowe.'),
    (7, 2, '2022-06-14', 'Badanie przeciwciał - zalecana szczepionka przeciwko wściekliźnie.'),
    (8, 1, '2022-05-07', 'Badanie skóry - wykryto niewielkie zmiany na skórze.'),
    (9, 3, '2022-04-30', 'Badanie ruchowości - zalecana rehabilitacja ruchowa.'),
    (10, 3, '2022-03-19', 'Badanie krwi - wyniki są prawidłowe.'),
    (11, 5, '2022-02-11', 'Badanie ogólne - wyniki są negatywne.'),
    (12, 2, '2022-01-02', 'Badanie bakteriologiczne - wykryto infekcję bakteryjną.'),
    (13, 1, '2021-12-27', 'Badanie terapeutyczne - zalecana terapia farmakologiczna.'),
    (14, 2, '2021-11-15', 'Badanie moczu - wyniki są prawidłowe.'),
    (15, 3, '2021-10-09', 'Badanie hormonalne - zalecana kontrola hormonalna.'),
    (16, 1, '2021-09-03', 'Badanie genetyczne - wyniki są negatywne.'),
    (17, 5, '2021-08-26', 'Badanie witaminowe - wykryto niski poziom witaminy D.'),
    (18, 3, '2021-07-18', 'Badanie ultrasonograficzne - zalecane badanie USG.'),
    (12, 1, '2021-06-11', 'Badanie krzyżowe - wyniki są pozytywne.'),
    (13, 1, '2021-05-03', 'Badanie żywieniowe - zalecana zmiana karmy.'),
    (4, 1, '2021-04-26', 'Badanie radiologiczne - wyniki są prawidłowe.'),
    (8, 5, '2021-03-19', 'Badanie neurologiczne - wykryto niewielkie zaburzenia.'),
    (13, 3, '2021-02-12', 'Badanie hormonalne - zalecana kontrola hormonalna.'),
    (12, 4, '2021-01-05', 'Badanie ogólne - wyniki są prawidłowe.'),
    (11, 2, '2020-12-01', 'Badanie krwi - wyniki są zadowalające.'),
    (1, 1, '2020-11-24', 'Badanie radiologiczne - zalecane badanie RTG.'),
    (6, 2, '2020-10-17', 'Badanie serologiczne - wyniki są negatywne.'),
    (7, 5, '2020-09-10', 'Badanie krwi - wykryto niedobór żelaza.'),
    (15, 3, '2020-08-03', 'Badanie ogólne - zalecana suplementacja witaminowa.'),
    (14, 4, '2020-07-27', 'Badanie stolca - wyniki są prawidłowe.');

-- 16 - Jednostki miary
INSERT INTO unit_of_measure (name, short) VALUES
    ('Mililitr', 'ml'),
    ('Gram', 'g'),
    ('Sztuka', 'szt'),
    ('Opakowanie', 'opk');

-- 17 - Inwentarz
INSERT INTO inventory (unit_id, name, amount, best_before) VALUES
    (2, 'Karma sucha', 20000.00, '2024-01-01'),
    (1, 'Szampon', 4000.00, '2023-12-31'),
    (1, 'Antybiotyk', 500.00, '2024-06-30'),
    (1, 'Odżywka', 600.00, '2023-10-15'),
    (1, 'Probiotyk', 75.00, '2024-02-28'),
    (3, 'Kołnierz ochronny', 15.00, '2023-11-30'),
    (2, 'Karma mokra', 8000.00, '2023-12-15'),
    (1, 'Przeciwpchelny preparat', 200, '2023-09-30'),
    (1, 'Karma dietetyczna', 3600.00, '2024-03-31'),
    (3, 'Szczotka do zębów', 20.00, '2023-11-15'),
    (4, 'Witaminy', 30.00, '2024-05-31'),
    (3, 'Obroża przeciwkleszczowa', 20.00, '2023-09-15'),
    (3, 'Miska ceramiczna', 10.00, '2023-12-31'),
    (1, 'Karma dla szczeniąt', 300.00, '2024-04-30'),
    (4, 'Bandaż', 90.00, '2026-03-30');

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
    (4, 4, '2023-04-15', '2024-04-15'),
    (5, 5, '2023-05-12', '2024-05-12'),
    (6, 1, '2022-06-20', '2024-06-20'),
    (7, 1, '2022-07-25', '2024-07-25'),
    (1, 2, '2022-08-22', '2024-08-22'),
    (2, 3, '2022-09-30', '2024-09-30'),
    (3, 4, '2022-10-25', '2024-10-25'),
    (4, 5, '2022-11-28', '2024-11-28'),
    (5, 5, '2022-12-15', '2024-12-15'),
    (6, 3, '2023-01-10', '2025-01-10'),
    (7, 2, '2023-02-18', '2025-02-18');