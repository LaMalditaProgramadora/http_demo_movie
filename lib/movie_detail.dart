import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'movie.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  final bool isFavorite;

  const MovieDetail(this.movie, this.isFavorite);

  @override
  _MovieDetailState createState() => _MovieDetailState(movie, isFavorite);
}

class _MovieDetailState extends State<MovieDetail> {
  DBHelper dbHelper = DBHelper();
  final Movie movie;
  final bool isFavorite;
  bool _isFavorite;

  _MovieDetailState(this.movie, this.isFavorite);

  @override
  void initState() {
    __isFavorite();
    super.initState();
  }

  Future __isFavorite() async {
    await dbHelper.openDb();
    bool check = await dbHelper.isFavorite(movie);
    setState(() {
      _isFavorite = check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  widget.movie.title,
                ),
                background: Image.network(
                  'https://image.tmdb.org/t/p/original/' +
                      widget.movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.favorite),
                color: _isFavorite ? Colors.red : Colors.grey,
                onPressed: () {
                  _isFavorite
                      ? dbHelper.deleteMovie(movie)
                      : dbHelper.insertMovie(movie);
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.movie.overview),
            ),
          ],
        ),
      ),
    );
  }
}
