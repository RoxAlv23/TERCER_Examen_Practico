import 'character.dart';

class CharacterPage {
  final int totalPages;
  final String? next;
  final String? previous;
  final List<Character> characters;

  const CharacterPage({
    required this.totalPages,
    required this.next,
    required this.previous,
    required this.characters,
  });

  factory CharacterPage.fromJson(Map<String, dynamic> json) {
    final info = json['info'] is Map
        ? json['info'] as Map
        : <dynamic, dynamic>{};
    final rawResults = json['results'];
    final results = rawResults is List
        ? rawResults
            .whereType<Map>()
            .map((item) => Character.fromJson(Map<String, dynamic>.from(item)))
            .toList()
        : <Character>[];

    return CharacterPage(
      totalPages: int.tryParse('${info['pages'] ?? 1}') ?? 1,
      next: info['next']?.toString(),
      previous: info['prev']?.toString(),
      characters: results,
    );
  }
}
