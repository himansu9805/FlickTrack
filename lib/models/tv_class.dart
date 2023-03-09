class TV {
  final int id;
  final String originalName;
  final String name;
  final double voteAverage;
  final String overview;
  final String posterPath;
  final List genreIds;
  final String releaseDate;

  const TV(
      {required this.id,
      required this.originalName,
      required this.name,
      required this.voteAverage,
      required this.overview,
      required this.posterPath,
      required this.genreIds,
      required this.releaseDate});

  factory TV.fromJson(Map<String, dynamic> json) {
    return TV(
        id: json['id'],
        originalName: json['original_name'],
        name: json['name'],
        voteAverage: json['vote_average'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        genreIds: json['genre_ids'],
        releaseDate: json['first_air_date']);
  }
}
