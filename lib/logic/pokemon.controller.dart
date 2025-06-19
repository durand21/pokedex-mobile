import 'package:flutter/material.dart';
import '../data/models/pokemon.model.dart';
import '../data/services/pokeapi.service.dart';

class PokemonController extends ChangeNotifier {
  final _api = PokeApiService();
  int _offset = 0;
  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;
  bool _hasMore = true;

  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  String? _error;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPokemon() async {
    _isLoading = true;
    _error = null;
    _offset = 0;
    _hasMore = true;
    notifyListeners();

    try {
      final data = await _api.fetchPokemonList(offset: _offset);
      _pokemonList = data;
      _offset += data.length;
      if (data.length < 20) _hasMore = false;
    } catch (e) {
      _error = 'Error al cargar Pokémon';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarMasPokemon() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners(); // notifica para mostrar loader

    try {
      final nuevos = await _api.fetchPokemonList(offset: _offset);
      _pokemonList.addAll(nuevos);
      _offset += nuevos.length;
      if (nuevos.length < 20) _hasMore = false;
    } catch (e) {
      _error = 'Error al cargar más Pokémon';
    }

    _isFetchingMore = false;
    notifyListeners(); // notifica para ocultar loader
  }
}
