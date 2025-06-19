import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config/config.dart';
import 'ui/pages/pages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'data/models/pokemon.model.dart';

/*class PokeApp extends StatelessWidget {
  PokeApp({super.key});
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> verificarSesionGoogle() async {
    try {
      final usuario = FirebaseAuth.instance.currentUser;
      if (usuario != null) return true;

      final cuenta = await _googleSignIn.signInSilently();
      if (cuenta == null) return false;

      final auth = await cuenta.authentication;
      final credencial = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credencial);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final usuario = snapshot.data;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Poke App',
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder:
                  (_) => FutureBuilder<bool>(
                    future: verificarSesionGoogle(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final estaAutenticado = snapshot.data!;
                      switch (settings.name) {
                        case '/':
                          return estaAutenticado
                              ? const HomePage()
                              : const LoginPage();
                        case '/home':
                          return estaAutenticado
                              ? const HomePage()
                              : const LoginPage();
                        case '/details':
                          return estaAutenticado
                              ? const DetailsPage()
                              : const LoginPage();
                        case '/login':
                          return const LoginPage();
                        default:
                          return const LoginPage();
                      }
                    },
                  ),
            );
          },
        );
      },
    );
  }
}
*/
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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.hasData ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}
