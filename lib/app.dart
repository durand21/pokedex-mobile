import 'package:flutter/material.dart';
import 'config/config.dart';
import 'ui/pages/home.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ui/pages/login.page.dart';

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke App',
      theme: AppTheme.lightTheme,
      routes: appRoutes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomePage(); // Usuario autenticado
          } else {
            return const LoginPage(); // Usuario no autenticado
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
