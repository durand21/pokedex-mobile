import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import '../../config/colors.dart';
import '../../data/services/evoluciones.service.dart';
import '../../data/services/pokeapi.service.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/shimmer_card.dart';
import '../../data/services/favs.service.dart';

class DetalleModal extends StatefulWidget {
  final Pokemon pokemon;
  const DetalleModal({super.key, required this.pokemon});

  @override
  State<DetalleModal> createState() => _DetalleModalState();
}

class _DetalleModalState extends State<DetalleModal> {
  late Future<bool> _enFavoritosFuture;

  @override
  void initState() {
    super.initState();
    _enFavoritosFuture = ServicioFavoritos().estaEnFavoritos(
      widget.pokemon.name,
    );
  }

  void _alternarFavorito(Pokemon poke) async {
    await ServicioFavoritos().alternarFavorito(poke);
    setState(() {
      _enFavoritosFuture = ServicioFavoritos().estaEnFavoritos(poke.name);
    });
  }

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
          future: obtenerPokemon(widget.pokemon.name),
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
                if (!snapEvo.hasData) {
                  return SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder:
                          (_, __) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: ShimmerCard(),
                          ),
                    ),
                  );
                }
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
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FutureBuilder<bool>(
                    future: _enFavoritosFuture,
                    builder: (context, snapshot) {
                      final enFavoritos = snapshot.data ?? false;
                      return FloatingActionButton(
                        backgroundColor:
                            enFavoritos
                                ? const Color.fromARGB(255, 252, 18, 2)
                                : Colors.grey,
                        tooltip:
                            enFavoritos
                                ? 'Quitar de favoritos'
                                : 'Agregar a favoritos',
                        onPressed: () => _alternarFavorito(poke),
                        child: Icon(
                          enFavoritos ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      );
                    },
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
