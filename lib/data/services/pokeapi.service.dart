import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.model.dart';

class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    final url = Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      final List<Pokemon> pokemons = [];
      for (var item in results) {
        final pokemon = Pokemon.fromJson(item);
        final types = await fetchPokemonTypes(pokemon.url);
        pokemons.add(pokemon.copyWithTypes(types));
      }

      return pokemons;
    } else {
      throw Exception('Error al cargar Pokémon');
    }
  }

  Future<List<String>> fetchPokemonTypes(String detailUrl) async {
    final response = await http.get(Uri.parse(detailUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final types = data['types'] as List;
      return types.map<String>((t) => t['type']['name'].toString()).toList();
    } else {
      return [];
    }
  }
}
