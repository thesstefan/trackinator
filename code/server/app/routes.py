from flask import jsonify, abort, request, Blueprint, current_app
import flask
import logging

from .models import db, Movie
from . import socketio

logger = logging.getLogger(__name__)
bp = Blueprint('movies', __name__, url_prefix='/movies')


@bp.route('/', methods=['GET'])
def get_movie_list() -> flask.Response:
    current_app.logger.debug('Received GET request for all movies')
    movies = Movie.query.all()

    response = jsonify({'movies': [movie.to_json() for movie in movies]})
    current_app.logger.debug(f'Responding with \t {response}')

    return response


@bp.route('/<int:id>', methods=['GET'])
def get_movie(id: int) -> flask.Response:
    current_app.logger.debug(f'Received GET request for movie with id={id}')

    movie = Movie.query.get(id)
    if movie is None:
        current_app.logger.debug(f'Movie with id={id} not found!')
        abort(404)

    response = jsonify(movie.to_json())
    current_app.logger.debug(f'Responding with \t {response}')

    return response


@bp.route('/', methods=['POST'])
def create_movie() -> flask.Response:
    assert request.json is not None

    current_app.logger.debug(
        f'Received POST request for movie \n\t {request.json}')
    movie = Movie.fromJson(request.json)

    db.session.add(movie)
    db.session.commit()
    current_app.logger.debug(f'Persisted movie \t {movie}')

    response = jsonify(movie.to_json())
    current_app.logger.debug(f'Responding with \t {response}')

    socketio.emit('new_movie', {'movie': movie.to_json()})

    return response


@bp.route('/sync', methods=['POST'])
def sync_movies() -> flask.Response:
    assert request.json is not None

    current_app.logger.debug(
        f'Received POST request for movie sync \n\t {request.json}')
    movieList = [Movie.fromJson(movieJson) for movieJson in request.json['movies']]

    for movie in movieList:
        if not db.session.query(Movie.id).filter(Movie.title == movie.title).count():
            db.session.add(movie)
            current_app.logger.debug(f'Persisted movie \t {movie}')
            socketio.emit('new_movie', {'movie': movie.to_json()})

    db.session.commit()

    response = jsonify(movie.to_json())
    current_app.logger.debug(f'Responding with \t {response}')

    return response


@bp.route('/<int:id>', methods=['POST'])
def update_movie(id: int) -> flask.Response:
    assert request.json is not None

    movie = Movie.query.get(id)
    old_movie = movie

    print(request.json.keys())

    movie.title = request.json['title']
    movie.dateWatched = request.json['dateWatched']
    movie.notes = request.json['notes']
    movie.rating = int(request.json['rating'])
    db.session.commit()

    socketio.emit('updated_movie', {'id': id, 'movie': movie.to_json()})

    return jsonify(old_movie.to_json())


@bp.route('/<int:id>', methods=['DELETE'])
def delete_movie(id: int) -> flask.Response:
    movie = Movie.query.filter_by(id=id).first()

    db.session.delete(movie)
    db.session.commit()

    socketio.emit('deleted_movie', {'id': id})

    return jsonify(movie.to_json())
