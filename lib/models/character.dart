class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String origin;
  final String location;
  final String image;
  final List<String> episodes;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episodes,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final originJson = json['origin'];
    final locationJson = json['location'];
    final rawEpisodes = json['episode'];

    return Character(
      id: _readInt(json['id']),
      name: _readString(json['name'], 'Nombre desconocido'),
      status: _readString(json['status'], 'Desconocido'),
      species: _readString(json['species'], 'Desconocida'),
      type: _readString(json['type'], 'Sin tipo adicional'),
      gender: _readString(json['gender'], 'Desconocido'),
      origin: originJson is Map
          ? _readString(originJson['name'], 'Desconocido')
          : 'Desconocido',
      location: locationJson is Map
          ? _readString(locationJson['name'], 'Desconocida')
          : 'Desconocida',
      image: _readString(json['image'], ''),
      episodes: rawEpisodes is List
          ? rawEpisodes.map((item) => item.toString()).toList()
          : <String>[],
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _readString(dynamic value, String fallback) {
    if (value == null) return fallback;
    final result = value.toString().trim();
    return result.isEmpty ? fallback : result;
  }
}
