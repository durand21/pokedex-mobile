import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/colors.dart';
import '../../data/services/evoluciones.service.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    final baseColor =
        pokemon.types.isNotEmpty
            ? typeColors[pokemon.types[0]] ?? Colors.grey
            : Colors.grey;

    final esPantallaAncha = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        title: Text(pokemon.name.toUpperCase()),
      ),
      body: FutureBuilder<List<String>>(
        future: ServicioEvolucion().obtenerEvoluciones(pokemon.id),
        builder: (context, snapshot) {
          final widgetEvoluciones =
              snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : snapshot.hasError
                  ? const Text('Error al cargar evoluciones')
                  : Wrap(
                    spacing: 12,
                    children:
                        snapshot.data!
                            .map(
                              (nombre) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${nombre.toLowerCase()}.png',
                                    height: 80,
                                    width: 80,
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.error),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    nombre.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                  );

          final imagenYTipos = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  width: 160,
                  height: 160,
                  placeholder:
                      (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children:
                    pokemon.types
                        .map(
                          (tipo) => Chip(
                            label: Text(tipo.toUpperCase()),
                            backgroundColor: typeColors[tipo] ?? Colors.black45,
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
              const Text('⚠️ Aquí irán las estadísticas (HP, ataque, etc.)'),
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
  }
}
