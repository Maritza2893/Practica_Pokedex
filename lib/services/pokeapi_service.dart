import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

Future<Pokemon> obtenerPokemon(String nombre) async {
  final url = Uri.parse(
    'https://pokeapi.co/api/v2/pokemon/${nombre.toLowerCase()}',
  );
  final respuesta = await http.get(url);

  if (respuesta.statusCode == 200) {
    return Pokemon.fromJson(
      jsonDecode(respuesta.body),
    );
  }

  else if (respuesta.statusCode == 404) {
    throw Exception('No se encontró el Pokémon');
  } else {
    throw Exception('Error: ${respuesta.statusCode}');
  }

}
