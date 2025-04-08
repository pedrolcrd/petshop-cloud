from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import os

app = Flask(__name__)
DATABASE = '/tmp/petshop.db'

def init_db():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS pets (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                especie TEXT NOT NULL,
                raca TEXT,
                cliente TEXT NOT NULL
            )
        ''')
        conn.commit()

@app.route('/')
def index():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM pets')
        pets = cursor.fetchall()
    return render_template('index.html', pets=pets)

@app.route('/cadastro', methods=['GET', 'POST'])
def cadastro_pet():
    if request.method == 'POST':
        pet = (
            request.form['nome'],
            request.form['especie'],
            request.form.get('raca', ''),
            request.form['cliente']
        )
        with sqlite3.connect(DATABASE) as conn:
            cursor = conn.cursor()
            cursor.execute('''
                INSERT INTO pets (nome, especie, raca, cliente)
                VALUES (?, ?, ?, ?)
            ''', pet)
            conn.commit()
        return redirect(url_for('index'))
    return render_template('cadastro_pet.html')

if __name__ == '__main__':
    init_db()
    app.run(debug=True)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/healthcheck')
def healthcheck():
    return "OK", 200
