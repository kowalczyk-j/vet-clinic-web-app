# -*- coding: utf-8 -*-

import pytest
from datetime import datetime
from flask import session
from app import app


@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.secret_key = "DJf939fj"
    with app.test_client() as client:
        with app.app_context():
            yield client


def test_home_page(client):
    response = client.get('/')
    assert response.status_code == 302
    assert response.location == '/patients'


def test_calendar_page(client):
    response = client.get('/calendar')
    assert response.status_code == 200
    assert b"Kalendarz" in response.data


def test_get_schedule_post(client):
    response = client.post('/get_schedule', data={'doctor_dropdown': '1'})
    assert response.status_code == 302
    assert response.location == '/schedule'
    assert session['events']


def test_get_schedule_get(client):
    with client.session_transaction() as sess:
        sess['events'] = [{'title': 'dr. Anna', 'daysOfWeek': '1', 'startTime': '09:00:00', 'endTime': '17:00:00'}]
    response = client.get('/get_schedule')
    assert response.status_code == 200
    assert b"title" in response.data
    assert b"daysOfWeek" in response.data
    assert b"startTime" in response.data
    assert b"endTime" in response.data


def test_schedule_page(client):
    response = client.get('/schedule')
    assert response.status_code == 200
    assert b"Harmonogram" in response.data


def test_delete_appointment_route(client):
    response = client.post('/delete_appointment/2', headers={'Referer': 'http://localhost/calendar'})
    assert response.status_code == 302
    assert response.location == 'http://localhost/calendar'


def test_postpone_appointment(client):
    response = client.post('/postpone_appointment/1', data={
        'new_day': '2023-06-02',
        'start_hour': '11:00'
    })
    assert response.status_code == 302
    assert response.location == '/calendar'


def test_payments_page(client):
    response = client.get('/payments')
    assert response.status_code == 200


def test_patients_page(client):
    response = client.get('/patients')
    assert response.status_code == 200
    assert b"Pacjenci" in response.data


def test_profile_page(client):
    response = client.get('/patients/2')
    assert response.status_code == 200
    assert b"Profil" in response.data


def test_add_owner_route(client):
    response = client.post('/add_owner', data={
        'name': 'John',
        'surname': 'Doe',
        'street': 'Main Street',
        'postal code': '12345',
        'city': 'City',
        'phone_number': '626456389',
        'pesel': '12345678901'
    }, headers={'Referer': 'http://localhost/patients'})
    assert response.status_code == 302
    assert response.location == 'http://localhost/patients'


def test_edit_owner(client):
    response = client.post('/edit_owner/12345678901', data={
        'name': 'John',
        'surname': 'Doe',
        'address': 'Main Street',
        'phone_number': '987654321'
    }, headers={'Referer': 'http://localhost/patients'})
    assert response.status_code == 302
    assert response.location == 'http://localhost/patients'


def test_delete_owner_route(client):
    response = client.post('/delete_owner/12345678901', headers={'Referer': 'http://localhost/patients'})
    assert response.status_code == 302
    assert response.location == 'http://localhost/patients'


def test_delete_animal_route(client):
    response = client.post('/delete_animal/1', headers={'Referer': 'http://localhost/patients/1'})
    assert response.status_code == 302
    assert response.location == 'http://localhost/patients/1'


def test_invalid_route(client):
    response = client.get('/invalid_route')
    assert response.status_code == 404
    assert b"404" in response.data
    assert b"Not Found" in response.data
