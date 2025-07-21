// lib/tv_show_model.dart

import 'api_constants.dart';

class TvShow {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;

  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  // Factory constructor para criar um TvShow a partir de um mapa JSON
  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      // Constrói a URL completa da imagem do pôster
      posterPath: json['poster_path'] != null 
                  ? '$tmdbImageBaseUrl${json['poster_path']}'
                  : 'https://placehold.co/500x750.png?text=No+Image', // Imagem padrão
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}