import 'package:flutter/material.dart';
import '../widgets/poke_appbar.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PokeAppBar(),
      body: Text('Pagina de detalles'),
    );
  }
}
