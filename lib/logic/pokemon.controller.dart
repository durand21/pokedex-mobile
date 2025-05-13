import 'package:flutter/material.dart';
import '../data/models/pokemon.model.dart';
import '../data/services/pokeapi.service.dart';

class PokemonController extends ChangeNotifier {
  final _api = PokeApiService();

  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  String? _error;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPokemon() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.fetchPokemonList();
      _pokemonList = data;
    } catch (e) {
      _error = 'Error al cargar Pokémon';
    }

    _isLoading = false;
    notifyListeners();
  }
}
