from app import create_app, socketio 

from app import events

app = create_app(debug=True)

if __name__ == '__main__':
    socketio.run(app)
