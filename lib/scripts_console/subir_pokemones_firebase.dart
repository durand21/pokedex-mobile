// archivo: scripts/subir_pokemones.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  // Obtener la cantidad total de Pokémon disponibles
  final countRes = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1'),
  );
  final totalCount = json.decode(countRes.body)['count'];

  print('Total de pokémon a cargar: $totalCount');

  // Obtener todos los Pokémon
  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$totalCount'),
  );
  final data = json.decode(response.body);
  final List results = data['results'];

  for (var item in results) {
    final name = item['name'];
    final url = item['url'];

    // Obtener tipos desde la URL del detalle
    final detailRes = await http.get(Uri.parse(url));
    final detailData = json.decode(detailRes.body);
    final types =
        (detailData['types'] as List)
            .map((t) => t['type']['name'] as String)
            .toList();

    await firestore.collection('pokemones').doc(name).set({
      'name': name,
      'url': url,
      'types': types,
    });

    print('Guardado: $name');
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Evitar rate limit
  }

  print('✔ Carga completa de todos los pokémon en Firestore');
}
