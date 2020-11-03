class Movie {
  int id;
  String title;
  String overview;
  String posterPath;
  Movie(this.id, this.title, this.overview, this.posterPath);

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.title = parsedJson['title'];
    this.overview = parsedJson['overview'];
    this.posterPath = parsedJson['poster_path'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
