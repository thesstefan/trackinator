from flask import Flask
from flask_socketio import SocketIO
import os

socketio = SocketIO()


def create_app(debug=False) -> Flask:
    app = Flask(__name__)
    app.debug = debug

    app.config.from_object('config.Config')

    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    from app.models import db
    db.init_app(app)

    from . import routes 
    app.register_blueprint(routes.bp)

    with app.app_context():
        db.create_all()

    socketio.init_app(app, )

    return app
