import 'package:flutter/material.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: onChange,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 700),
        child: listMode
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
  _MovieRowState(this.movie, this.listMode);
  bool isFavorite;

  @override
  void initState() {
    isFavorite = false;
    super.initState();
  }

  void goDetails() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => MovieDetail(movie)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: Column(
        children: [
          ListTile(
            leading: Hero(
              tag: movie.title,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Image.network(
                  'https://image.tmdb.org/t/p/original/' + movie.posterPath,
                ),
              ),
            ),
            title: listMode ? Text(movie.title) : Text(""),
            //subtitle: Text(movie.overview),

            trailing: IconButton(
              icon: Icon(Icons.favorite),
              color: isFavorite ? Colors.red : Colors.grey,
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
            onTap: () => goDetails(),
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
