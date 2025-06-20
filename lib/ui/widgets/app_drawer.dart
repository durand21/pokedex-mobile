import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(usuario?.displayName ?? 'Sin nombre'),
            accountEmail: Text(usuario?.email ?? 'Sin correo'),
            currentAccountPicture:
                usuario?.photoURL != null
                    ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        usuario!.photoURL!,
                      ),
                    )
                    : const CircleAvatar(child: Icon(Icons.person, size: 42)),
            decoration: const BoxDecoration(color: Colors.redAccent),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favoritos'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/favoritos',
                (_) => false,
              );
            },
          ),
          //ListTile(
          //  leading: const Icon(Icons.logout),
          //  title: const Text('Cerrar sesión'),
          //  onTap: () async {
          //    await FirebaseAuth.instance.signOut();
          //    Navigator.pushReplacementNamed(context, '/login');
          //  },
          //),
        ],
      ),
    );
  }
}
