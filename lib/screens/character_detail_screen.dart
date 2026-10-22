import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../state/app_state.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;
  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favorite = state.isFavorite(character.id);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del personaje')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: AspectRatio(
              aspectRatio: 1.12,
              child: Image.network(character.image, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF252B36), child: Icon(Icons.person, size: 100)),
                loadingBuilder: (_, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(character.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: _statusColor(character.status), shape: BoxShape.circle)),
            const SizedBox(width: 8), Text(character.status),
          ]),
          const SizedBox(height: 18),
          Card(child: Column(children: [
            _infoRow(context, 'Especie', character.species, Icons.biotech),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(context, 'Género', character.gender, Icons.person_outline),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(context, 'Origen', character.origin, Icons.public),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(context, 'Última ubicación', character.location, Icons.place_outlined),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(context, 'Tipo', character.type, Icons.category_outlined),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(context, 'Episodios', '${character.episodes.length}', Icons.tv),
          ])),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              final saved = await context.read<AppState>().toggleFavorite(character);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(saved
                    ? (favorite ? 'Personaje eliminado de favoritos.' : 'Personaje agregado a favoritos.')
                    : 'No se pudo guardar el cambio en el dispositivo.'),
              ));
            },
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
            label: Text(favorite ? 'Quitar de favoritos' : 'Agregar a favoritos'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: const Color(0xFFB8E986)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60)),
          const SizedBox(height: 3), Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ])),
      ]),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive': return Colors.greenAccent;
      case 'dead': return Colors.redAccent;
      default: return Colors.orangeAccent;
    }
  }
}
