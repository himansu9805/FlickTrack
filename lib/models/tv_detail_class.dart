class TVDetail {
  final int id;
  final bool inProduction;
  final String originalLanguage;
  final List productionCompanies;
  final List productionCountries;
  final String status;
  final String tagline;

  const TVDetail({
    required this.id,
    required this.inProduction,
    required this.originalLanguage,
    required this.productionCompanies,
    required this.productionCountries,
    required this.status,
    required this.tagline,
  });

  factory TVDetail.fromJson(Map<String, dynamic> json) {
    return TVDetail(
      id: json['id'],
      inProduction: json['in_production'],
      originalLanguage: json['original_language'],
      productionCompanies: json['production_companies'],
      productionCountries: json['production_countries'],
      status: json['status'],
      tagline: json['tagline'],
    );
  }
}
