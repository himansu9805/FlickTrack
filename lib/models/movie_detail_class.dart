class MovieDetail {
  final int id;
  final String originalLanguage;
  final List productionCompanies;
  final List productionCountries;
  final String status;
  final String tagline;

  const MovieDetail({
    required this.id,
    required this.originalLanguage,
    required this.productionCompanies,
    required this.productionCountries,
    required this.status,
    required this.tagline,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      originalLanguage: json['original_language'],
      productionCompanies: json['production_companies'],
      productionCountries: json['production_countries'],
      status: json['status'],
      tagline: json['tagline'],
    );
  }
}
