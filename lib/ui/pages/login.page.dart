import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Aquí puedes agregar la lógica de inicio de sesión
            Navigator.pushNamed(context, '/home');
          },
          child: const Text('Iniciar Sesión'),
        ),
      ),
    );
  }
}
