from flask import Flask, render_template
from flask_socketio import SocketIO, send, emit
import socketio as sio
from multiprocessing import Process
import logging
import time

logging.basicConfig(level=logging.DEBUG)



app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret'
socketio = SocketIO(app)


@app.route('/')
def index():
    return render_template('index.html')


@socketio.on('connect')
def handle_connect():
    print('Client connected')
    send_message('Welcome to the server!')

@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

def send_message(message):
    print('sending message')
    emit('message', message, broadcast=True)

@socketio.on('message')
def handle_incoming_message(data):
    print('received: ' + str(data))

@socketio.on('new-barcode')
def handle_local_message(data):
    print('received: ' + str(data))
    emit('barcode', data['data'], broadcast=True)

def setup_client_socket():
    print('setup client')

    client_socket = sio.Client()

    @client_socket.event
    def connect(): print('local connect')

    @client_socket.event
    def disconnect(): print('local disconnect')

    print('connect to local server...')
    client_socket.connect('http://localhost:5001')
    print('connect attempted')
    return client_socket

        # i = 0
        # while i < 5:
        #     print('sending new message from local client to local server')
        #     client_socket.emit('my-msg', {'data':'look it is new data ' + str(i)})
        #     i+= 1
        #     time.sleep(2)
    
def launch_server():
    print('launching...')
    socketio.run(app, host='0.0.0.0', port=5001, allow_unsafe_werkzeug=True)

def launch_server_process():
    p = Process(target=launch_server, args=())
    p.start()

def launch_socketio_server():

    launch_server_process()

    setup_client_socket()



if __name__ == "__main__":

    launch_socketio_server()
