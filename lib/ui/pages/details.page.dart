import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import '../../config/colors.dart';
import '../../data/services/evoluciones.service.dart';
import '../../data/services/pokeapi.service.dart';
import '../widgets/poke_appbar.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/shimmer_card.dart';
import 'package:shimmer/shimmer.dart';

/*class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  Future<List<Pokemon>> obtenerEvoluciones(int id) async {
    final evoluciones = await ServicioEvolucion().obtenerEvoluciones(id);
    final nombres = evoluciones.map((e) => e.nombre).toList();
    final pokes = await PokeApiService().fetchPokemonPorNombre(nombres);
    return pokes;
  }

  @override
  Widget build(BuildContext context) {
    final _pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    final esPantallaAncha = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: const PokeAppBar(),
      body: FutureBuilder<Pokemon>(
        future: PokeApiService()
            .fetchPokemonPorNombre([_pokemon.name])
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
                        ? Wrap(
                          spacing: 12,
                          children: List.generate(
                            3,
                            (_) => const ShimmerCard(),
                          ),
                        )
                        : snapshot.hasError
                        ? Text(snapshot.toString())
                        : Wrap(
                          spacing: 12,
                          children:
                              snapshot.data!.map((evo) {
                                return PokemonCard(
                                  pokemon: evo,
                                  navegable: true,
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
                    pokemon.stats.isEmpty
                        ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Column(
                            children: List.generate(
                              6,
                              (index) => Container(
                                width: double.infinity,
                                height: 20,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        )
                        : Column(
                          children:
                              pokemon.stats
                                  .map(
                                    (stat) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              stat['name'].toUpperCase(),
                                            ),
                                          ),
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value:
                                                  (stat['value'] as int) /
                                                  150.0,
                                              color: baseColor,
                                              backgroundColor: baseColor
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(stat['value'].toString()),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
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
}*/

class DetalleModal extends StatelessWidget {
  final Pokemon pokemon;
  const DetalleModal({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final esAncho = MediaQuery.of(context).size.width > 800;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: FutureBuilder<Pokemon>(
          future: obtenerPokemon(pokemon.name),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final poke = snap.data!;
            final baseColor = typeColors[poke.types[0]] ?? Colors.grey;

            final imagenYTipos = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 160,
                      maxWidth: 220,
                    ),
                    child: PokemonCard(pokemon: poke, navegable: false),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children:
                      poke.types
                          .map(
                            (tipo) => Chip(
                              label: Text(tipo.toUpperCase()),
                              backgroundColor: typeColors[tipo],
                              labelStyle: const TextStyle(color: Colors.white),
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
                ...poke.stats.map(
                  (s) => Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(s['name'].toUpperCase()),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (s['value'] as int) / 150.0,
                          backgroundColor: baseColor.withOpacity(0.2),
                          color: baseColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${s['value']}'),
                    ],
                  ),
                ),
              ],
            );

            final evoluciones = FutureBuilder<List<Pokemon>>(
              future: obtenerEvoluciones(poke.id),
              builder: (context, snapEvo) {
                if (!snapEvo.hasData) return const CircularProgressIndicator();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evoluciones',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 12,
                        children:
                            snapEvo.data!.map((evo) {
                              return GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                    const Duration(milliseconds: 100),
                                  );
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => DetalleModal(pokemon: evo),
                                    );
                                  }
                                },
                                child: PokemonCard(pokemon: evo),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );

            return Stack(
              children: [
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child:
                          esAncho
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 350, child: imagenYTipos),
                                      const SizedBox(width: 40),
                                      SizedBox(width: 400, child: estadisticas),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0,
                                    ),
                                    child: evoluciones,
                                  ),
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
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Pokemon> obtenerPokemon(String nombre) async {
    final lista = await PokeApiService().fetchPokemonPorNombre([nombre]);
    return lista.first;
  }

  Future<List<Pokemon>> obtenerEvoluciones(int id) async {
    final nombres =
        (await ServicioEvolucion().obtenerEvoluciones(
          id,
        )).map((e) => e.nombre).toList();
    return await PokeApiService().fetchPokemonPorNombre(nombres);
  }
}
