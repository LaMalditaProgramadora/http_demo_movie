import 'package:flutter/material.dart';

import 'http_helper.dart';
import 'movie.dart';

class MovieList extends StatefulWidget {
  MovieList({Key key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List movies;
  int moviesCount;
  HttpHelper httpHelper;

  @override
  void initState() {
    httpHelper = HttpHelper();
    movies = List();
    moviesCount = 0;
    loadMore();
    super.initState();
  }

  Future loadMore() async {
    List result = await httpHelper.getUpcoming();
    setState(() {
      moviesCount = result.length;
      movies = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return MovieRow(movies[index]);
          }),
    );
  }
}

class MovieRow extends StatefulWidget {
  final Movie movie;
  MovieRow(this.movie);

  @override
  _MovieRowState createState() => _MovieRowState(movie);
}

class _MovieRowState extends State<MovieRow> {
  final Movie movie;
  _MovieRowState(this.movie);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
                maxWidth: 84,
                maxHeight: 84,
              ),
              child: Image.network(
                  'https://image.tmdb.org/t/p/original/' + movie.posterPath),
            ),
            title: Text(movie.title),
            subtitle: Text(movie.overview),
          ),
        ],
      ),
    );
  }
}
