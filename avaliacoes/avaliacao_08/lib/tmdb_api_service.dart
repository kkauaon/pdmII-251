// lib/tmdb_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'tv_show_model.dart';

class TmdbApiService {
  
  // Endpoint para séries em alta (trending) no período de uma semana
  static const String _trendingShowsEndpoint = '/trending/tv/week';

  Future<List<TvShow>> fetchTrendingShows() async {
    // Constrói a URL final com a chave da API
    final uri = Uri.parse('$tmdbApiBaseUrl$_trendingShowsEndpoint?api_key=$tmdbApiKey&language=pt-BR');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List results = data['results']; // A API do TMDB retorna os resultados em uma chave "results"
        
        // Mapeia a lista de resultados para uma lista de objetos TvShow
        return results.map((showJson) => TvShow.fromJson(showJson)).toList();
      } else {
        // Lança um erro se a resposta não for OK
        throw Exception('Falha ao carregar séries. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Lança um erro para problemas de conexão, timeout, etc.
      throw Exception('Erro de conexão: $e');
    }
  }
}