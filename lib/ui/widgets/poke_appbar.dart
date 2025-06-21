import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PokeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PokeAppBar({super.key});

  void _cerrarSesion(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    //Navigator.pushNamedAndRemoveUntil(context, '/splash', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              tooltip: 'Abrir menú',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      title: Image.asset('assets/images/logo.png', height: 40),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.redAccent),
          tooltip: 'Cerrar sesión',
          onPressed: () => _cerrarSesion(context),
        ),
      ],
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
