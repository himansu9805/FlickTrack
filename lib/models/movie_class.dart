class Movie {
  final int id;
  final String originalTitle;
  final String title;
  final double voteAverage;
  final String overview;
  final String posterPath;
  final List genreIds;
  final String releaseDate;

  const Movie(
      {required this.id,
      required this.originalTitle,
      required this.title,
      required this.voteAverage,
      required this.overview,
      required this.posterPath,
      required this.genreIds,
      required this.releaseDate});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        originalTitle: json['original_title'],
        title: json['title'],
        voteAverage: json['vote_average'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        genreIds: json['genre_ids'],
        releaseDate: json['release_date']);
  }
}
