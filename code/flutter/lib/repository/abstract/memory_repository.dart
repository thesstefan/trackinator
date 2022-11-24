import 'package:trackinator_flutter_v2/model/entity.dart';
import 'package:trackinator_flutter_v2/repository/abstract/repository.dart';

class MemoryRepository<T extends Entity> implements Repository<T> {
  Map<int, T> items = {};

  @override
  Future<void> delete(int id) async {
    items.remove(id);
  }

  @override
  Future<List<T>> getAll() async {
    return Future<List<T>>.value(items.values.toList());
  }

  @override
  Future<T> getMovie(int id) async {
    return Future<T>.value(items[id]);
  }

  @override
  Future<void> insert(T movie) async {
    items[movie.id] = movie;
  }

  @override
  Future<void> update(int id, T movie) async {
    movie.id = id;
    items[id] = movie;
  }
}