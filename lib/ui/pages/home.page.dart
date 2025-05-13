import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/pokemon.controller.dart';
import '../../data/models/pokemon.model.dart';

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
      body: ListView.builder(
        itemCount: controller.pokemonList.length,
        itemBuilder: (context, index) {
          final pokemon = controller.pokemonList[index];
          return ListTile(
            leading: Image.network(pokemon.imageUrl),
            title: Text(pokemon.name),
            subtitle: Text('ID: ${pokemon.id}'),
          );
        },
      ),
    );
  }
}
