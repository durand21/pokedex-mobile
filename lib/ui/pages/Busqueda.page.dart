import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import '../../data/services/busqueda_pokemon.service.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/poke_appbar.dart';
import '../widgets/app_drawer.dart';

class BusquedaPage extends StatelessWidget {
  final String textoBusqueda;
  const BusquedaPage({super.key, required this.textoBusqueda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PokeAppBar(),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Pokemon>>(
        future: ServicioBusquedaPokemon().buscarPorNombre(textoBusqueda),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final resultados = snapshot.data ?? [];

          if (resultados.isEmpty) {
            return const Center(child: Text('No se encontraron Pokémon.'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: resultados.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return PokemonCard(pokemon: resultados[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
