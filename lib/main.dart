import 'package:flutter/material.dart';

import 'movie_list.dart';

void main() => runApp(MyMovies());

class MyMovies extends StatelessWidget {
  const MyMovies({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MovieList();
  }
}