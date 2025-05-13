import 'package:flutter/material.dart';

class PokeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PokeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Image.asset('../../../../assets/images/logo.png', height: 40),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: Row(
          children: List.generate(20, (index) {
            final isEven = index % 2 == 0;
            return Expanded(
              child: Container(
                height: 4, // para grosor de la barra
                color: isEven ? Colors.blue : Colors.yellow,
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
}
