import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'movie.dart';

class HttpHelper {
  final String urlKey = 'api_key=3cae426b920b29ed2fb1c0749f258325';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlPopular = '/popular?';

  Future<List> getMovies(type) async {
    String urlMovies;
    if (type == 0) urlMovies = urlBase + urlUpcoming + urlKey;
    else urlMovies = urlBase + urlPopular + urlKey;
    http.Response result = await http.get(urlMovies);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];

      List movies = moviesMap.map((value) => Movie.fromJson(value)).toList();
      return movies;
    } else {
      return null;
    }
  }
}
