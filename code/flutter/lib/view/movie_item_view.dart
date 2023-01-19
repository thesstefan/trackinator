import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:trackinator_flutter_v2/service/movie_service.dart';
import 'package:trackinator_flutter_v2/service/socket_movie_service.dart';
import 'package:trackinator_flutter_v2/view/movie_details_view.dart';

class MovieItemView extends StatelessWidget {
  final int movieId;
  const MovieItemView({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
        future:
            Provider.of<SocketMovieService>(context, listen: true).getMovie(movieId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var movie = snapshot.data!;

            return Card(
                elevation: 20.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(0.0),
                child: InkWell(
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (context) {
                            return MovieDetailsView(movieId: movie.id);
                      })
                    )
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.network(movie.imageUrl!, fit: BoxFit.fitHeight),
                      Text(movie.title!),
                      RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: movie.rating!.toDouble(),
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 35,
                        onRatingUpdate: (double value) {},
                      )
                    ])));
          } else if (snapshot.hasError) {
            return const Text("Error");
          }

          return const Text("Loading");
        });
  }
}
