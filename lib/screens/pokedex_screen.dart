import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokeapi_service.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final _controlador = TextEditingController();
  Future<Pokemon>? _futuroPokemon;

  void _buscar() {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) return;
    setState(() {
      _futuroPokemon = obtenerPokemon(texto);
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC62828),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Encabezado de bienvenida
            const Text(
              'Descubre el mundo Pokémon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Consulta la información de tu Pokémon favorito',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _controlador,
              decoration: InputDecoration(
                labelText: 'Nombre o número del Pokémon',

                // Icono de búsqueda
                prefixIcon: const Icon(Icons.search, color: Color(0xFFC62828)),

                // Texto de ejemplo
                hintText: 'Ejemplo: Pikachu o 25',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _buscar,
                icon: const Icon(Icons.search),
                label: const Text(
                  'Buscar Pokémon',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _futuroPokemon == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.catching_pokemon,
                            size: 90,
                            color: Color(0xFFBDBDBD),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Encuentra tu Pokémon',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Escribe su nombre o número para comenzar',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : FutureBuilder<Pokemon>(
                      future: _futuroPokemon,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFFC62828),
                                  strokeWidth: 4,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Buscando Pokémon...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('${snapshot.error}'));
                        }
                        final pokemon = snapshot.data!;

                        return Column(
                          children: [
                            Image.network(pokemon.imagen, height: 180),
                            Text(
                              '#${pokemon.id} - ${pokemon.nombre}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              children: pokemon.tipos
                                  .map((tipo) => Chip(label: Text(tipo)))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Altura: ${pokemon.altura.toStringAsFixed(1)} m',
                            ),
                            Text('Peso: ${pokemon.peso.toStringAsFixed(1)} kg'),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
