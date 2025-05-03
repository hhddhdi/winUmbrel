from flask import Flask, request, redirect
import json
import os

app = Flask(__name__)

@app.route('/')
def index():
    return open("index.html").read()

@app.route('/start', methods=['POST'])
def start():
    config = {
        "WIN_VERSION": request.form['version'],
        "RAM_SIZE": request.form['ram'],
        "CPU_CORES": request.form['cpu'],
        "DISK_SIZE": request.form['disk']
    }
    with open("/app/config/windows-config.json", "w") as f:
        json.dump(config, f)
    os.system("docker restart windows")
    return "Configuração salva! Reiniciando a VM..."

app.run(host='0.0.0.0', port=80)
