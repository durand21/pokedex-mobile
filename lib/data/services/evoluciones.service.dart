import 'dart:convert';
import 'package:http/http.dart' as http;

class Evolucion {
  final String nombre;
  final int id;

  Evolucion({required this.nombre, required this.id});
}

class ServicioEvolucion {
  final String urlBase = 'https://pokeapi.co/api/v2';

  Future<List<Evolucion>> obtenerEvoluciones(int idPokemon) async {
    try {
      final urlEspecie = '$urlBase/pokemon-species/$idPokemon';
      final respuestaEspecie = await http.get(Uri.parse(urlEspecie));
      if (respuestaEspecie.statusCode != 200) {
        throw Exception('Error al obtener la especie');
      }

      final datosEspecie = json.decode(respuestaEspecie.body);
      final urlEvolucion = datosEspecie['evolution_chain']['url'];

      final respuestaEvo = await http.get(Uri.parse(urlEvolucion));
      if (respuestaEvo.statusCode != 200) {
        throw Exception('Error al obtener la evolución');
      }

      final datosEvo = json.decode(respuestaEvo.body);
      List<String> nombres = [];

      void extraerNombres(dynamic cadena) {
        if (cadena == null) return;
        nombres.add(cadena['species']['name']);
        if (cadena['evolves_to'] != null && cadena['evolves_to'].isNotEmpty) {
          extraerNombres(cadena['evolves_to'][0]);
        }
      }

      extraerNombres(datosEvo['chain']);

      // Buscar el ID de cada Pokémon
      List<Evolucion> evoluciones = [];
      for (String nombre in nombres) {
        final respuesta = await http.get(Uri.parse('$urlBase/pokemon/$nombre'));
        if (respuesta.statusCode == 200) {
          final data = json.decode(respuesta.body);
          evoluciones.add(Evolucion(nombre: nombre, id: data['id']));
        }
      }

      return evoluciones;
    } catch (e) {
      print('Error al cargar las evoluciones: $e');
      return [];
    }
  }
}
