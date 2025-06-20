// lib/data/services/favoritos.service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/pokemon.model.dart';

class ServicioFavoritos {
  final CollectionReference favoritosRef = FirebaseFirestore.instance
      .collection('favoritos');

  Future<List<Pokemon>> obtenerFavoritos() async {
    final snapshot = await favoritosRef.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Pokemon(
        name: data['name'],
        url: data['url'],
        types: List<String>.from(data['types'] ?? []),
        stats: List<Map<String, dynamic>>.from(data['stats'] ?? []),
      );
    }).toList();
  }
}
