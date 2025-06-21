import 'package:app_test/ui/pages/splash.page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config/config.dart';
import 'ui/pages/pages.dart';

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poke App',
      theme: AppTheme.lightTheme,

      routes: appRoutes /*{
        '/home': (_) => const HomePage(),
        '/login': (_) => const LoginPage(),
        '/details': (_) => const DetailsPage(),
      }*/,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage();
          }
          return snapshot.hasData ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}
