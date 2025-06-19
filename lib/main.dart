import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'logic/pokemon.controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonController()..loadPokemon(),
      child: const PokeApp(),
    ),
  );
}
