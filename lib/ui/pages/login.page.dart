import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> iniciarSesionConGoogle(BuildContext contexto) async {
    try {
      final cuentaGoogle =
          await GoogleSignIn(
            clientId:
                '572556484221-l6iusl16h1r54ob2ns0h9gsb9hdlpmsh.apps.googleusercontent.com',
          ).signIn();

      if (cuentaGoogle == null)
        return; // El usuario canceló el inicio de sesión
      // Obtiene el token de autenticación de Google
      final autenticacion = await cuentaGoogle.authentication;
      final credencial = GoogleAuthProvider.credential(
        accessToken: autenticacion.accessToken,
        idToken: autenticacion.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credencial);
    } catch (e) {
      ScaffoldMessenger.of(
        contexto,
      ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
      print('Error al iniciar sesión con Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Iniciar sesión en Pokédex',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Continuar con Google'),
              onPressed: () => iniciarSesionConGoogle(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
