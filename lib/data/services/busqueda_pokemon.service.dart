import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon.model.dart';

class ServicioBusquedaPokemon {
  final _ref = FirebaseFirestore.instance.collection('pokemones');

  Future<List<Pokemon>> buscarPorNombre(String texto) async {
    final snapshot =
        await _ref
            .where('name', isGreaterThanOrEqualTo: texto.toLowerCase())
            .where('name', isLessThan: texto.toLowerCase() + 'z')
            .limit(20)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Pokemon(
        name: data['name'],
        url: data['url'],
        types: List<String>.from(data['types'] ?? []),
        stats: List<Map<String, dynamic>>.from(data['stats'] ?? []),
      );
    }).toList();
  }
}
