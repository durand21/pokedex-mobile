import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/pokemon.controller.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/poke_appbar.dart';
import '../widgets/app_drawer.dart';
import './Busqueda.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = context.read<PokemonController>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !controller.isFetchingMore) {
      controller.cargarMasPokemon();
    }
  }

  void _verificarBusqueda(String texto) {
    final txt_limpio = texto.trim();
    if (txt_limpio.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BusquedaPage(textoBusqueda: txt_limpio),
        ),
      );
      _busquedaController.clear();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PokemonController>();

    if (controller.isLoading && controller.pokemonList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.error != null && controller.pokemonList.isEmpty) {
      return Scaffold(body: Center(child: Text(controller.error!)));
    }

    return Scaffold(
      appBar: const PokeAppBar(),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            TextField(
              controller: _busquedaController,
              decoration: const InputDecoration(
                hintText: 'Buscar Pokémon...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _verificarBusqueda,
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                itemCount: controller.pokemonList.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final pokemon = controller.pokemonList[index];
                  return PokemonCard(pokemon: pokemon);
                },
              ),
            ),
            if (controller.isFetchingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
