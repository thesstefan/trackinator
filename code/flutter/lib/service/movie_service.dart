import 'package:flutter/cupertino.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:trackinator_flutter_v2/repository/abstract/repository.dart';

class MovieService extends ChangeNotifier {
  final Repository<Movie> movieRepository;
  int newId = 10;

  MovieService(this.movieRepository) {
    // loadDefaultMovies();
  }

  void loadDefaultMovies() {
    notifyListeners();
  }

  Future<void> addMovie(String date, String title,
                String url, String notes, int rating) async {
    newId += 1;
    await movieRepository.insert(Movie(newId, date, title, url, notes, rating));
    notifyListeners();
  }

  Future<void> removeMovie(int id) async {
    await movieRepository.delete(id);
    notifyListeners();
  }

  Future<void> updateMovie(int id, String date, String title,
                   String url, String notes, int rating) async {
    await movieRepository.update(id, Movie(id, date, title, url, notes, rating));
    notifyListeners();
  }

  Future<Movie> getMovie(int id) async => await movieRepository.getById(id);

  Future<List<Movie>> getAllMovies() async => await movieRepository.getAll();
}