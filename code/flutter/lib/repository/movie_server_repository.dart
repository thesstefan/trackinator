import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:trackinator_flutter_v2/repository/abstract/repository.dart';
import 'package:http/http.dart' as http;

class MovieServerRepository with ChangeNotifier implements Repository<Movie> {
  static const String movieApiEndpoint = 'http://10.0.2.2:5000/movies';

  MovieServerRepository._privateConstructor();

  static final MovieServerRepository instance =
      MovieServerRepository._privateConstructor();

  @override
  Future<List<Movie>> getAll() async {
    var response = await http.get(Uri.parse(movieApiEndpoint));

    if (response.statusCode == 200) {
      var jsonMovieList = json.decode(response.body)['movies'] as List;

      return jsonMovieList.map((jsonMovie) => Movie.fromJson(jsonMovie)).toList();
    }

    throw Exception('Get all failed!');
  }

  @override
  Future<Movie> getById(int id) async {
    var response = await http.get(Uri.parse('$movieApiEndpoint/$id'));

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    }

    throw Exception('Get by id ($id) failed!');
  }

  @override
  Future<void> delete(int id) async {
    await http.delete(Uri.parse('$movieApiEndpoint/$id'));
  }

  @override
  Future<void> insert(Movie movie) async {
    Map<String, String> headers = HashMap();
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';

    await http.post(Uri.parse(movieApiEndpoint),
        headers: headers, body: movie.movieMap());
  }

  @override
  Future<void> update(int id, Movie movie) async {
    Map<String, String> headers = HashMap();
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';

    await http.post(Uri.parse('$movieApiEndpoint/$id'),
        headers: headers, body: movie.movieMap());
  }

  Future<List<Movie>> sync(List<Movie> localMovies) async {
    Map<String, String> headers = HashMap();
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';

    var moviesJson = json.encode({
      'movies': localMovies.map((Movie movie) => movie.movieMap()).toList()
    });
    await http.post(Uri.parse('$movieApiEndpoint/sync'),
        headers: headers, body: moviesJson);

    return getAll();
  }
}
