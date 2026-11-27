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
            TextField(
              controller: _controlador,
              decoration: const InputDecoration(
                labelText: 'Nombre o número del Pokémon',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _buscar, child: const Text('Buscar')),
            const SizedBox(height: 24),
            Expanded(
              child: _futuroPokemon == null
                  ? const Center(
                      child: Text('Escribe un nombre y presiona Buscar'),
                    )
                  : FutureBuilder<Pokemon>(
                      future: _futuroPokemon,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
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
