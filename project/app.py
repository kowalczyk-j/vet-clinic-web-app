from flask import Flask, render_template, request, redirect
from src.data_access import get_owner_by_id, get_all_owners, add_owner

app = Flask(__name__)


@app.route('/')
def index():
    owners = get_all_owners()
    print(owners)
    return render_template('owners.html', owners=owners)


@app.route('/add_owner', methods=['POST'])
def add_owner_route():
    name = request.form['name']
    surname = request.form['surname']
    address = request.form['address']
    phone_number = request.form['phone_number']
    pesel = request.form['pesel']
    add_owner(name, surname, address, phone_number, pesel)
    return redirect('/')


if __name__ == '__main__':
    app.run()
