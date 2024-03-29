import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackinator_flutter_v2/repository/movie_server_repository.dart';
import 'package:trackinator_flutter_v2/service/movie_service.dart';
import 'package:trackinator_flutter_v2/service/socket_movie_service.dart';
import 'package:trackinator_flutter_v2/view/movie_dashboard_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (_) => SocketMovieService(),
        child: const MaterialApp(
            title: 'Trackinator',
            home: Scaffold(
              body: MovieDashboardView(),
            )
        )
    ),
  );
}