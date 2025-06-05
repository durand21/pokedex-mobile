import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/colors.dart';
import '../../data/services/evoluciones.service.dart';
import '../../data/services/pokeapi.service.dart';
import '../widgets/poke_appbar.dart';
import '../widgets/pokemon_card.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  Future<List<Pokemon>> obtenerEvoluciones(int id) async {
    final evoluciones = await ServicioEvolucion().obtenerEvoluciones(id);
    final nombres = evoluciones.map((e) => e.nombre).toList();
    final pokes = await PokeApiService().fetchPokemonPorNombre(nombres);
    return pokes;
  }

  @override
  Widget build(BuildContext context) {
    final argumento = ModalRoute.of(context)!.settings.arguments as Pokemon;
    final esPantallaAncha = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: const PokeAppBar(),
      body: FutureBuilder<Pokemon>(
        future: PokeApiService()
            .fetchPokemonPorNombre([argumento.name])
            .then((list) => list.first),
        builder: (context, snapshotPokemon) {
          if (snapshotPokemon.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshotPokemon.hasError || snapshotPokemon.data == null) {
            return const Center(child: Text('Error al cargar Pokémon'));
          }

          final pokemon = snapshotPokemon.data!;
          final baseColor =
              pokemon.types.isNotEmpty
                  ? typeColors[pokemon.types[0]] ?? Colors.grey
                  : Colors.grey;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<List<Pokemon>>(
              future: obtenerEvoluciones(pokemon.id),
              builder: (context, snapshot) {
                final widgetEvoluciones =
                    snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : snapshot.hasError
                        ? Text(snapshot.toString())
                        : Wrap(
                          spacing: 12,
                          children:
                              snapshot.data!.map((evo) {
                                return PokemonCard(
                                  pokemon: evo,
                                  navegable: false,
                                );
                              }).toList(),
                        );

                final imagenYTipos = Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: PokemonCard(pokemon: pokemon, navegable: false),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children:
                          pokemon.types
                              .map(
                                (tipo) => Chip(
                                  label: Text(tipo.toUpperCase()),
                                  backgroundColor:
                                      typeColors[tipo] ?? Colors.black45,
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                );

                final estadisticas = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estadísticas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...pokemon.stats.map(
                      (stat) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(stat['name'].toUpperCase()),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: (stat['value'] as int) / 150.0,
                                color: baseColor,
                                backgroundColor: baseColor.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(stat['value'].toString()),
                          ],
                        ),
                      ),
                    ),
                  ],
                );

                final evoluciones = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evoluciones',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    widgetEvoluciones,
                  ],
                );

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child:
                      esPantallaAncha
                          ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(child: imagenYTipos),
                              const SizedBox(width: 20),
                              Expanded(child: estadisticas),
                              const SizedBox(width: 20),
                              Expanded(child: evoluciones),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              imagenYTipos,
                              const SizedBox(height: 24),
                              estadisticas,
                              const SizedBox(height: 24),
                              evoluciones,
                            ],
                          ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
