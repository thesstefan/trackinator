import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackinator_flutter_v2/repository/movie_memory_repository.dart';
import 'package:trackinator_flutter_v2/service/movie_service.dart';
import 'package:trackinator_flutter_v2/view/movie_dashboard_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (_) => MovieService(MovieMemoryRepository()),
        child: const MaterialApp(
            title: 'Trackinator',
            home: Scaffold(
              body: MovieDashboardView(),
            )
        )
    ),
  );
}