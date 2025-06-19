import 'package:app_test/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import '../../config/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool navegable;
  const PokemonCard({super.key, required this.pokemon, this.navegable = true});

  @override
  Widget build(BuildContext context) {
    final baseColor =
        typeColors[pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal'] ??
        Colors.grey;
    final baseColorDark = Color.alphaBlend(
      Colors.black.withOpacity(0.2),
      baseColor,
    );

    // Contenido de la card
    final contenido = Container(
      margin: const EdgeInsets.all(
        4,
      ), // const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
        color: baseColor, // fondo sólido por tipo
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: baseColorDark /*Colors.black87*/,
          width: 2,
        ), // borde estilo carta
        boxShadow: [
          BoxShadow(
            color: baseColor, // Colors.black26,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage('assets/images/backgrounds/aura.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  fit: BoxFit.contain,
                  placeholder:
                      (context, url) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),

            Text(
              pokemon.name.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    return navegable
        ? GestureDetector(
          onTap: () {
            // Navegar a la pantalla de detalles del Pokémon
            showDialog(
              context: context,
              barrierDismissible: true,
              builder:
                  (_) => Dialog(
                    insetPadding: const EdgeInsets.all(16),
                    backgroundColor: Colors.transparent,
                    child: DetalleModal(pokemon: pokemon),
                  ),
            );
            //Navigator.pushNamed(context, '/details', arguments: pokemon);
          },
          child: contenido,
        )
        : contenido;
  }
}
