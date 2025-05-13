class Pokemon {
  final String name;
  final String url;

  const Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  /// Extrae el ID del Pokémon desde la URL
  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    return int.tryParse(segments[segments.length - 2]) ?? 0;
  }

  /// Construye la URL de la imagen oficial
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}
