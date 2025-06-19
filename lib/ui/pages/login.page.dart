import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './home.page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> iniciarSesionConGoogle(BuildContext context) async {
    try {
      final cuentaGoogle = await GoogleSignIn().signIn();
      if (cuentaGoogle == null) return; // usuario canceló

      final autenticacion = await cuentaGoogle.authentication;
      final credencial = GoogleAuthProvider.credential(
        accessToken: autenticacion.accessToken,
        idToken: autenticacion.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credencial);

      // Navega al Home si fue exitoso
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      print("Error al iniciar sesión con Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocurrió un error al iniciar sesión")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Iniciar sesión con Google"),
          onPressed: () => iniciarSesionConGoogle(context),
        ),
      ),
    );
  }
}
