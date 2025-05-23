import 'package:flutter/material.dart';
import 'config/config.dart';
import 'ui/pages/home.page.dart';

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke App',
      theme: AppTheme.lightTheme,
      routes: appRoutes,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
