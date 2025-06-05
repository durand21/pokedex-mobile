import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicioEvolucion {
  final String urlBase = 'https://pokeapi.co/api/v2';

  Future<List<String>> obtenerEvoluciones(int idPokemon) async {
    try {
      // 1. Obtener los datos de especie para acceder a la cadena de evolución
      final urlEspecie = '$urlBase/pokemon-species/$idPokemon';
      final respuestaEspecie = await http.get(Uri.parse(urlEspecie));
      if (respuestaEspecie.statusCode != 200) {
        throw Exception('Error al obtener la especie');
      }

      final datosEspecie = json.decode(respuestaEspecie.body);
      final urlEvolucion = datosEspecie['evolution_chain']['url'];

      // 2. Obtener la cadena de evolución
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
          extraerNombres(
            cadena['evolves_to'][0],
          ); // Solo tomamos la primera evolución
        }
      }

      extraerNombres(datosEvo['chain']);
      return nombres;
    } catch (e) {
      print('Error al cargar las evoluciones: $e');
      return [];
    }
  }
}
