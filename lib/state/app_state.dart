import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character.dart';
import '../models/character_page.dart';
import '../services/character_api.dart';

class AppState extends ChangeNotifier {
  final CharacterApi _api = CharacterApi();
  static const String _favoritesKey = 'favorite_character_ids';

  bool isLoading = false;
  bool isInitialized = false;
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 1;
  List<Character> characters = [];
  final Set<int> favoriteIds = {};
  final Map<int, Character> _characterCache = {};

  List<Character> get favorites {
    return favoriteIds
        .map((id) => _characterCache[id])
        .whereType<Character>()
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      favoriteIds.addAll(
        (prefs.getStringList(_favoritesKey) ?? []).map((value) => int.tryParse(value)).whereType<int>(),
      );
    } catch (_) {
      // La aplicación puede continuar aunque no estén disponibles las preferencias.
    }
    isInitialized = true;
    await loadPage(1);
    await loadSavedFavorites();
    notifyListeners();
  }

  Future<void> loadPage(int page) async {
    if (isLoading || page < 1 || (totalPages > 1 && page > totalPages)) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final CharacterPage result = await _api.getCharacters(page);
      currentPage = page;
      totalPages = result.totalPages;
      characters = result.characters;
      for (final character in characters) {
        _characterCache[character.id] = character;
      }
    } catch (error) {
      errorMessage = error is ApiException
          ? error.message
          : 'Ocurrió un error al cargar los personajes.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedFavorites() async {
    final missing = favoriteIds.where((id) => !_characterCache.containsKey(id)).toList();
    for (final id in missing) {
      try {
        _characterCache[id] = await _api.getCharacter(id);
      } catch (_) {
        // Se conserva el identificador para intentar recuperar el personaje más tarde.
      }
    }
    notifyListeners();
  }

  bool isFavorite(int id) => favoriteIds.contains(id);

  Future<bool> toggleFavorite(Character character) async {
    if (favoriteIds.contains(character.id)) {
      favoriteIds.remove(character.id);
    } else {
      favoriteIds.add(character.id);
      _characterCache[character.id] = character;
    }
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, favoriteIds.map((id) => id.toString()).toList());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }
}
