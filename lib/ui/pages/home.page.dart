import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/pokemon.controller.dart';
import '../widgets/pokemon_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PokemonController>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.error != null) {
      return Scaffold(body: Center(child: Text(controller.error!)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Poke App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: GridView.builder(
          itemCount: controller.pokemonList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // máximo ancho por tarjeta
            childAspectRatio: 3 / 4, // alto/ancho (más vertical)
            crossAxisSpacing: 12, // espacio entre tarjetas en el eje X
            mainAxisSpacing: 12, // espacio entre tarjetas en el eje Y
          ),
          itemBuilder: (context, index) {
            final pokemon = controller.pokemonList[index];
            return PokemonCard(pokemon: pokemon);
          },
        ),
      ),
    );
  }
}
