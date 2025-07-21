// lib/trending_shows_screen.dart

import 'package:flutter/material.dart';
import 'tmdb_api_service.dart';
import 'tv_show_model.dart';

class TrendingShowsScreen extends StatefulWidget {
  const TrendingShowsScreen({super.key});

  @override
  State<TrendingShowsScreen> createState() => _TrendingShowsScreenState();
}

class _TrendingShowsScreenState extends State<TrendingShowsScreen> {
  late Future<List<TvShow>> _futureShows;
  final TmdbApiService _apiService = TmdbApiService();

  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  void _loadShows() {
    setState(() {
      _futureShows = _apiService.fetchTrendingShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Séries em alta nesta semana'),
        backgroundColor: const Color(0xFF032541), // Cor primária do TMDB
      ),
      body: FutureBuilder<List<TvShow>>(
        future: _futureShows,
        builder: (context, snapshot) {
          // 1. Estado de Carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Estado de Erro
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadShows,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }
          // 3. Estado de Sucesso
          else if (snapshot.hasData) {
            final shows = snapshot.data!;
            return ListView.builder(
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pôster da Série
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            show.posterPath,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                            // Widget de carregamento para a imagem
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : const SizedBox(
                                      width: 100,
                                      height: 150,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Informações da Série
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                show.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    show.voteAverage.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                show.overview,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          // Estado padrão
          return const Center(child: Text('Nenhuma série encontrada.'));
        },
      ),
    );
  }
}