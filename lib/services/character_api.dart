import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';
import '../models/character_page.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class CharacterApi {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';
  final http.Client _client;

  CharacterApi({http.Client? client}) : _client = client ?? http.Client();

  Future<CharacterPage> getCharacters(int page) async {
    final uri = Uri.parse('$_baseUrl/character?page=$page');
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map<String, dynamic>) return CharacterPage.fromJson(decoded);
        throw const ApiException('La respuesta recibida no tiene el formato esperado.');
      }
      throw ApiException('El servidor respondió con código ${response.statusCode}.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('No se pudo conectar. Revisa tu internet e inténtalo de nuevo.');
    }
  }

  Future<Character> getCharacter(int id) async {
    final uri = Uri.parse('$_baseUrl/character/$id');
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map<String, dynamic>) return Character.fromJson(decoded);
        throw const ApiException('La respuesta del personaje no es válida.');
      }
      throw ApiException('No se pudo cargar el personaje (${response.statusCode}).');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('No se pudo cargar este personaje. Comprueba la conexión.');
    }
  }

  void dispose() => _client.close();
}
