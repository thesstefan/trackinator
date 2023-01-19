import 'package:flutter/material.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:provider/provider.dart';
import 'package:trackinator_flutter_v2/service/movie_service.dart';
import 'package:trackinator_flutter_v2/service/socket_movie_service.dart';
import 'package:trackinator_flutter_v2/view/movie_add_view.dart';

import 'movie_item_view.dart';

class MovieDashboardView extends StatefulWidget {
  const MovieDashboardView({super.key});

  @override
  _MovieDashboardViewState createState() => _MovieDashboardViewState();
}

class _MovieDashboardViewState extends State<MovieDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Movie',
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (context) {
              return const MovieAddView();
            }));
          },
          child: const Icon(Icons.movie),
        ),
        body: FutureBuilder<List<Movie>>(
            future:
                Provider.of<SocketMovieService>(context, listen: true).getAllMovies(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.54,
                    ),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var movie = snapshot.data?[index];

                      return MovieItemView(movieId: movie!.id);
                    });
              } else if (snapshot.hasError) {
                return const Text("Error");
              }

              return const Text("Loading");
            }));
  }
}
