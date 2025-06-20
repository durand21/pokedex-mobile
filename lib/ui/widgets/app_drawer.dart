import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Menú')),
          ListTile(
            title: const Text('Inicio'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Favoritos'),
            leading: const Icon(Icons.favorite),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/favs');
            },
          ),
        ],
      ),
    );
  }
}
