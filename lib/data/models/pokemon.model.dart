class Pokemon {
  final String name;
  final String url;
  final List<String> types;
  final List<Map<String, dynamic>> stats;

  const Pokemon({
    required this.name,
    required this.url,
    this.types = const [], // por defecto vacío
    this.stats = const [], // por defecto vacío
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('url')) {
      // Formato de lista
      return Pokemon(name: json['name'], url: json['url']);
    } else {
      final statsList =
          (json['stats'] as List).map<Map<String, dynamic>>((s) {
            return {'name': s['stat']['name'], 'value': s['base_stat']};
          }).toList();
      // Formato detallado /pokemon/:id
      return Pokemon(
        name: json['name'],
        url: 'https://pokeapi.co/api/v2/pokemon/${json['id']}/',
        stats: statsList,
      );
    }
  }

  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    return int.tryParse(segments[segments.length - 2]) ?? 0;
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  Pokemon copyWithTypes(List<String> types) {
    return Pokemon(name: name, url: url, types: types, stats: stats);
  }
}
