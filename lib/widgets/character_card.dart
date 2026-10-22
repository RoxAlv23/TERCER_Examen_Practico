import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../state/app_state.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({super.key, required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favorite = appState.isFavorite(character.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xFF252B36),
                      child: Icon(Icons.person, size: 64, color: Colors.white54),
                    ),
                    loadingBuilder: (context, child, progress) => progress == null
                        ? child
                        : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: favorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
                        onPressed: () async {
                          final saved = await context.read<AppState>().toggleFavorite(character);
                          if (!context.mounted) return;
                          if (!saved) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No se pudo guardar el cambio en el dispositivo.')),
                            );
                          }
                        },
                        icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                            color: favorite ? Colors.pinkAccent : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(character.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 5),
                  Row(children: [
                    _statusDot(character.status),
                    const SizedBox(width: 5),
                    Expanded(child: Text(character.status, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall)),
                  ]),
                  const SizedBox(height: 4),
                  Text(character.species, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFFB8E986))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusDot(String status) {
    final lower = status.toLowerCase();
    final color = lower == 'alive' ? Colors.greenAccent : (lower == 'dead' ? Colors.redAccent : Colors.orangeAccent);
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
