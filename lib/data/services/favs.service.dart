// lib/data/services/favoritos.service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/pokemon.model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServicioFavoritos {
  CollectionReference get favoritosRef {
    final usuario = FirebaseAuth.instance.currentUser;
    final uid = usuario?.uid ?? 'anonimo';
    return FirebaseFirestore.instance.collection('favoritos_$uid');
  }

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

  Future<bool> estaEnFavoritos(String nombre) async {
    final doc = await favoritosRef.doc(nombre).get();
    return doc.exists;
  }

  Future<void> alternarFavorito(Pokemon pokemon) async {
    final ref = favoritosRef.doc(pokemon.name);
    final existe = await ref.get();
    if (existe.exists) {
      await ref.delete(); // quitar de favoritos
    } else {
      await ref.set({
        'name': pokemon.name,
        'url': pokemon.url,
        'types': pokemon.types,
        'stats': pokemon.stats,
      }); // agregar a favoritos
    }
  }
}
