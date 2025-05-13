import 'package:flutter/material.dart';
import '../../data/models/pokemon.model.dart';
import '../../config/colors.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final bgColor =
        typeColors[pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal'] ??
        Colors.grey;
    final bgColorWithOpacity = bgColor.withValues(
      alpha: (0.81 * 255).toDouble(),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: pokemon);
      },
      child: Card(
        color: bgColorWithOpacity,
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                pokemon.imageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              Text(
                pokemon.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ver más...',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
