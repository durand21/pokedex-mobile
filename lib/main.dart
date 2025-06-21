import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'logic/pokemon.controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  final controlador = PokemonController();
  await controlador.loadPokemon();

  runApp(ChangeNotifierProvider(create: (_) => controlador, child: PokeApp()));
}
