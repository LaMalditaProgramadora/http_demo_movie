import 'package:flutter/material.dart';
import 'package:http_demo_movie/db_helper.dart';

import 'http_helper.dart';
import 'movie.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  MovieList({Key key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List movies;
  int moviesCount;
  HttpHelper httpHelper;
  bool listMode;
  int movieType = 0;

  @override
  void initState() {
    httpHelper = HttpHelper();
    movies = List();
    moviesCount = 0;
    listMode = true;
    loadMore();
    super.initState();
  }

  void onChange() {
    setState(() {
      listMode = !listMode;
    });
  }

  void onChangeMovieType() {
    setState(() {
      if (movieType == 0)
        movieType = 1;
      else
        movieType = 0;
    });
    initState();
  }

  Future loadMore() async {
    List result = await httpHelper.getMovies(movieType);
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
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: onChange,
          ),
          IconButton(
            icon: Icon(Icons.movie),
            onPressed: onChangeMovieType,
          ),
        ],
      ),
      body: listMode
          ? ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return MovieRow(movies[index], listMode);
              },
            )
          : GridView.builder(
              itemCount: movies.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return MovieRow(movies[index], listMode);
              },
            ),
    );
  }
}

class MovieRow extends StatefulWidget {
  final Movie movie;
  final bool listMode;
  MovieRow(this.movie, this.listMode);

  @override
  _MovieRowState createState() => _MovieRowState(movie, listMode);
}

class _MovieRowState extends State<MovieRow> {
  final Movie movie;
  final bool listMode;
  DBHelper dbHelper;
  _MovieRowState(this.movie, this.listMode);
  bool isFavorite;

  @override
  void initState() {
    dbHelper = DBHelper();
    _isFavorite();
    super.initState();
  }

  void goDetails(isFavorite) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => MovieDetail(movie, isFavorite)));
  }

  Future _isFavorite() async {
    await dbHelper.openDb();
    bool check = await dbHelper.isFavorite(movie);
    setState(() {
      isFavorite = check;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isFavorite();
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: Column(
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/original/' + movie.posterPath,
              ),
            ),
            title: listMode ? Text(movie.title) : Text(""),
            //subtitle: Text(movie.overview),

            trailing: IconButton(
              icon: Icon(Icons.favorite),
              color: isFavorite ? Colors.red : Colors.grey,
              onPressed: () {
                isFavorite
                    ? dbHelper.deleteMovie(movie)
                    : dbHelper.insertMovie(movie);
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
            onTap: () => goDetails(isFavorite),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: listMode
                ? null
                : Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(movie.title),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
