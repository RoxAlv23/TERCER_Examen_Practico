import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMissing();
  }

  Future<void> _loadMissing() async {
    setState(() => _loading = true);
    await context.read<AppState>().loadSavedFavorites();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favorites = state.favorites;
    return Scaffold(
      appBar: AppBar(title: const Text('Mis favoritos')),
      body: _loading && favorites.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.favorite_border, size: 58, color: Colors.pinkAccent),
                    const SizedBox(height: 12),
                    const Text('Todavía no tienes favoritos.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Regresa al catálogo y toca el corazón de un personaje.', textAlign: TextAlign.center),
                    if (state.favoriteIds.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      TextButton.icon(onPressed: _loadMissing, icon: const Icon(Icons.refresh), label: const Text('Intentar cargar de nuevo')),
                    ],
                  ]),
                ))
              : GridView.builder(
                  padding: const EdgeInsets.all(14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.61, crossAxisSpacing: 12, mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final character = favorites[index];
                    return CharacterCard(
                      character: character,
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CharacterDetailScreen(character: character),
                      )),
                    );
                  },
                ),
    );
  }
}
