import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/app_drawer.dart';
import '../../data/services/favs.service.dart'; // importa tu servicio

class PaginaFavoritos extends StatelessWidget {
  const PaginaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Pokemon>>(
        future:
            ServicioFavoritos()
                .obtenerFavoritos(), // <--- aquí usas tu servicio
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final favoritos = snapshot.data!;
          if (favoritos.isEmpty) {
            return const Center(child: Text('No hay favoritos aún.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: favoritos.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: favoritos[index]);
            },
          );
        },
      ),
    );
  }
}
