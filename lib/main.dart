import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'logic/pokemon.controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonController()..loadPokemon(),
      child: const PokeApp(),
    ),
  );
}
