class Pokemon {
  final String name;
  final String url;
  final List<String> types;

  const Pokemon({
    required this.name,
    required this.url,
    this.types = const [], // por defecto vacío
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    return int.tryParse(segments[segments.length - 2]) ?? 0;
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  Pokemon copyWithTypes(List<String> types) {
    return Pokemon(name: name, url: url, types: types);
  }
}
