import 'package:trackinator_flutter_v2/model/entity.dart';

class Movie extends Entity {
  String? dateWatched;
  String? title;
  String? imageUrl;
  String? notes;
  int? rating;

  Movie(super.id, this.dateWatched, this.title,
        this.imageUrl, this.notes, this.rating);

  movieMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['dateWatched'] = dateWatched!;
    mapping['title'] = title!;
    mapping['imageUrl'] = imageUrl!;
    mapping['notes'] = notes!;
    mapping['rating'] = rating!;

    return mapping;
  }
}