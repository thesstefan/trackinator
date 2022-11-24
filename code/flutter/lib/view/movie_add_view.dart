import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:trackinator_flutter_v2/service/movie_service.dart';
import 'package:trackinator_flutter_v2/view/movie_dashboard_view.dart';

class MovieAddView extends StatefulWidget {
  const MovieAddView({super.key});

  @override
  State<MovieAddView> createState() => _MovieAddViewState();
}

class _MovieAddViewState extends State<MovieAddView> {
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

  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController();
    var dateController = TextEditingController();
    var urlController = TextEditingController();
    var notesController = TextEditingController();

    var rating = 1;
    var ratingBar = RatingBar.builder(
        initialRating: 1,
        direction: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, _) =>
            const Icon(Icons.star, color: Colors.amber),
        itemSize: 35,
        onRatingUpdate: (double value) {
          rating = value.toInt();
        });

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
          ListTile(
              title: TextField(
                  maxLines: null,
                  controller: titleController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.title), labelText: 'Movie Title'))),
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
                      icon: Icon(Icons.image), labelText: 'Image URL'))),
          ListTile(
              title: TextField(
                  maxLines: null,
                  controller: notesController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.notes), labelText: 'Notes'))),
          ratingBar,
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      showInvalidDataDialog();

                      return;
                    }
                    Provider.of<MovieService>(context, listen: false)
                        .addMovie(dateController.text, titleController.text,
                            urlController.text, notesController.text, rating)
                        .whenComplete(() => Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (context) {
                              return const MovieDashboardView();
                            })));
                  },
                  child: const Text('Add Movie'))),
        ])));
  }
}
