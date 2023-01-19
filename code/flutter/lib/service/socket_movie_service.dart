import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:trackinator_flutter_v2/repository/movie_server_repository.dart';
import 'package:trackinator_flutter_v2/repository/movie_sql_repository.dart';

class SocketMovieService extends ChangeNotifier {
  MovieServerRepository serverRepository = MovieServerRepository.instance;
  late MovieSqlRepository localRepository = MovieSqlRepository.instance;

  late socket_io.Socket webSocket;
  bool online = false;
  static const String webSocketEndpoint = 'ws://10.0.2.2:5000';

  SocketMovieService() {
    webSocket = socket_io.io(webSocketEndpoint, <String, dynamic>{
      "transports": ["websocket"]
    });
    webSocket.onConnect((_) {
      log('Connected to WebSocket... I\'m online!');
      online = true;
      sync().then((self) => notifyListeners());
    });
    webSocket.onDisconnect((_) {
      log('Disconnected from WebSocket... I\'m offline');
      online = false;
    });
    webSocket.on('new_movie', (data) {
      var movie = Movie.fromJson(data['movie']);
      log('New movie on server -> $movie');

      localRepository.insert(movie).then((self) => notifyListeners());
    });
    webSocket.on('deleted_movie', (data) {
      log('Movie with id ${data['id']} removed from server!');

      localRepository.delete(data['id']).then((self) => notifyListeners());
    });
    webSocket.on('updated_movie', (data) {
      log('Movie with id ${data['id']} updated on server to ${data['movie']}');

      localRepository
          .update(data['id'], Movie.fromJson(data['movie']))
          .then((self) => notifyListeners());
    });
  }

  Future<void> addMovie(
      String date, String title, String url, String notes, int rating) async {
    var movie = Movie(-1, date, title, url, notes, rating);

    if (online) {
      serverRepository.insert(movie);
    } else {
      localRepository.insert(movie).then((self) => notifyListeners());
    }
  }

  Future<void> removeMovie(int id) async {
    if (online) {
      serverRepository.delete(id);
    } else {}
  }

  Future<void> updateMovie(int id, String date, String title, String url,
      String notes, int rating) async {
    if (online) {
      var movie = Movie(id, date, title, url, notes, rating);
      serverRepository.update(id, movie);
    } else {}
  }

  Future<Movie> getMovie(int id) async => await localRepository.getById(id);

  Future<List<Movie>> getAllMovies() async => await localRepository.getAll();

  Future<void> sync() async {
    if (!online) {
      return;
    }

    var localMovies = await localRepository.getAll();
    var remoteMovies = await serverRepository.sync(localMovies);

    await localRepository.deleteAll();

    for (var movie in remoteMovies) {
      localRepository.insert(movie);
    }
  }
}
