import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:trackinator_flutter_v2/service/movie_service.dart';
import 'package:trackinator_flutter_v2/view/movie_dashboard_view.dart';

class MovieDetailsView extends StatefulWidget {
  final int movieId;

  const MovieDetailsView({super.key, required this.movieId});

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  void showInvalidDataDialog() {
    Widget okButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning"),
      content: const Text('Movie data is invalid. Try again!'),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showDeleteDialog() {
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Provider.of<MovieService>(context, listen: false)
            .removeMovie(widget.movieId)
            .whenComplete(() => Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (context) {
                  return const MovieDashboardView();
                })));
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning"),
      content: const Text(
          'Are you sure you want to remove this movie?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Movie>(
            future: Provider.of<MovieService>(context, listen: true)
                .getMovie(widget.movieId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var movie = snapshot.data!;

                var titleController = TextEditingController(text: movie.title);
                var dateController =
                    TextEditingController(text: movie.dateWatched);
                var urlController = TextEditingController(text: movie.imageUrl);
                var notesController = TextEditingController(text: movie.notes);

                var rating = movie.rating;
                var ratingBar = RatingBar.builder(
                    initialRating: movie.rating!.toDouble(),
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemSize: 35,
                    onRatingUpdate: (double value) {
                      rating = value.toInt();
                    });

                return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      Image.network(movie.imageUrl!, fit: BoxFit.fitHeight),
                      ratingBar,
                      ListTile(
                          title: TextField(
                              maxLines: null,
                              controller: titleController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.title),
                                  labelText: 'Movie Title'))),
                      ListTile(
                          title: TextField(
                              controller: dateController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  labelText: 'Date Watched'))),
                      ListTile(
                          title: TextField(
                              controller: urlController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.image),
                                  labelText: 'Image URL'))),
                      ListTile(
                          title: TextField(
                              maxLines: null,
                              controller: notesController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.notes),
                                  labelText: 'Notes'))),
                      Center(
                          child: ElevatedButton(
                              onPressed: () {
                                if (titleController.text.isEmpty) {
                                  showInvalidDataDialog();

                                  return;
                                }
                                Provider.of<MovieService>(context,
                                        listen: false)
                                    .updateMovie(
                                        movie.id,
                                        dateController.text,
                                        titleController.text,
                                        urlController.text,
                                        notesController.text,
                                        rating!)
                                    .whenComplete(() => Navigator.pop(context));
                              },
                              child: const Text('Update Movie'))),
                      Center(
                        child: ElevatedButton(
                          onPressed: () { showDeleteDialog(); },
                          child: const Text('Delete Movie')
                        )
                      )
                    ]));
              } else if (snapshot.hasError) {
                return const Text("Error");
              }

              return const Text("Loading");
            }));
  }
}
