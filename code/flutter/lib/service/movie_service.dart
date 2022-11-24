import 'package:flutter/cupertino.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:trackinator_flutter_v2/repository/abstract/repository.dart';

class MovieService extends ChangeNotifier {
  final Repository<Movie> movieRepository;
  int newId = 10;

  MovieService(this.movieRepository) {
    loadDefaultMovies();
  }

  void loadDefaultMovies() {
    List<Movie> defaultMovies = [
      Movie(1, 'DATE', 'Pulp Fiction', 'https://cdn.shopify.com/s/files/1/0057/3728/3618/products/pulpfiction.2436_480x.progressive.jpg?v=1620048742', 'NOTES', 5),
      Movie(2, 'DATE', 'Alien', 'https://cdn.shopify.com/s/files/1/0057/3728/3618/products/ffd005c1c156c002d6318d24e08c3e60_027e0963-448d-457f-a46b-5db0550dc0c1_480x.progressive.jpg?v=1573587257', 'NOTES', 2),
      Movie(3, 'DATE', 'Terminator 2: Judgement Day', 'https://cdn.shopify.com/s/files/1/0057/3728/3618/products/55cea2691f42048d74ea7a4f39b7afa1_480x.progressive.jpg?v=1573572639', 'NOTES', 3),
      Movie(4, 'DATE', 'Home Alone', 'https://cdn.shopify.com/s/files/1/0057/3728/3618/products/dd43b3a44eacfd9ff0a3d97b311d17d2_b4766a06-e1c1-421d-acdb-3adae5c2c645_480x.progressive.jpg?v=1573652567', 'NOTES', 5),
      Movie(5, 'DATE', 'Star Wars', 'https://cdn.shopify.com/s/files/1/0057/3728/3618/products/6cd691e19fffbe57b353cb120deaeb8f_8489d7bf-24ba-4848-9d0f-11f20cb35025_480x.progressive.jpg?v=1573613877', 'NOTES', 5)
    ];

    for (var movie in defaultMovies) { movieRepository.insert(movie); }

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
    await movieRepository.update(id, Movie(-1, date, title, url, notes, rating));
    notifyListeners();
  }

  Future<Movie> getMovie(int id) async => await movieRepository.getMovie(id);

  Future<List<Movie>> getAllMovies() async => await movieRepository.getAll();
}