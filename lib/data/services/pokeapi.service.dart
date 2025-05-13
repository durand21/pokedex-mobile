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

      return results.map((item) => Pokemon.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar Pokémon');
    }
  }
}
