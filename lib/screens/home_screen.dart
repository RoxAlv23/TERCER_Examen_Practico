import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../state/app_state.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final List<Character> visibleCharacters = state.characters.where((character) {
      return character.name.toLowerCase().contains(_search.trim().toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Rick and Morty', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Explorador de personajes', style: TextStyle(fontSize: 12, color: Colors.white60)),
        ]),
        actions: [
          IconButton(
            tooltip: 'Mis favoritos',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
            icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _search = value),
                decoration: InputDecoration(
                  hintText: 'Buscar personaje por nombre',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _search.isEmpty ? null : IconButton(
                    tooltip: 'Limpiar búsqueda',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _search = '');
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Row(children: [
                const Icon(Icons.info_outline, size: 16, color: Color(0xFFB8E986)),
                const SizedBox(width: 7),
                Expanded(child: Text('La búsqueda se realiza solo en la página actual.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70))),
              ]),
            ),
            Expanded(child: _buildBody(state, visibleCharacters)),
            _buildPagination(state),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppState state, List<Character> visibleCharacters) {
    if (state.isLoading && state.characters.isEmpty) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(), SizedBox(height: 14), Text('Cargando personajes...'),
      ]));
    }
    if (state.errorMessage != null && state.characters.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off, size: 48, color: Colors.orangeAccent),
          const SizedBox(height: 12),
          Text(state.errorMessage!, textAlign: TextAlign.center),
          const SizedBox(height: 14),
          FilledButton.icon(onPressed: () => state.loadPage(state.currentPage), icon: const Icon(Icons.refresh), label: const Text('Reintentar')),
        ]),
      ));
    }
    if (visibleCharacters.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.search_off, size: 48, color: Colors.white54),
          const SizedBox(height: 12),
          Text(_search.isEmpty ? 'No hay personajes para mostrar.' : 'No se encontraron coincidencias en esta página.', textAlign: TextAlign.center),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 8), Text(state.errorMessage!, textAlign: TextAlign.center),
            TextButton(onPressed: () => state.loadPage(state.currentPage), child: const Text('Reintentar')),
          ],
        ]),
      ));
    }
    return Stack(children: [
      GridView.builder(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.61, crossAxisSpacing: 12, mainAxisSpacing: 12,
        ),
        itemCount: visibleCharacters.length,
        itemBuilder: (context, index) {
          final character = visibleCharacters[index];
          return CharacterCard(
            character: character,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => CharacterDetailScreen(character: character),
            )),
          );
        },
      ),
      if (state.isLoading)
        const Positioned(top: 8, right: 18, child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))),
      if (state.errorMessage != null)
        Positioned(left: 12, right: 12, top: 8, child: Material(
          color: Colors.deepOrange.shade900,
          borderRadius: BorderRadius.circular(10),
          child: Padding(padding: const EdgeInsets.all(8), child: Text(state.errorMessage!, textAlign: TextAlign.center)),
        )),
    ]);
  }

  Widget _buildPagination(AppState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(color: Color(0xFF171C25)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        OutlinedButton.icon(
          onPressed: state.currentPage > 1 && !state.isLoading ? () => state.loadPage(state.currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left), label: const Text('Anterior'),
        ),
        Text('Página ${state.currentPage} de ${state.totalPages}', style: const TextStyle(fontWeight: FontWeight.w600)),
        OutlinedButton.icon(
          onPressed: state.currentPage < state.totalPages && !state.isLoading ? () => state.loadPage(state.currentPage + 1) : null,
          icon: const Icon(Icons.chevron_right), label: const Text('Siguiente'),
          iconAlignment: IconAlignment.end,
        ),
      ]),
    );
  }
}
