import 'package:trackinator_flutter_v2/model/entity.dart';

abstract class Repository<T extends Entity> {
  Future<List<T>> getAll();
  Future<T> getById(int id);
  Future<void> insert(T movie);
  Future<void> update(int id, T movie);
  Future<void> delete(int id);
}