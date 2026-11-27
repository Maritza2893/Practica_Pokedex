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

  Color _colorTipo(String tipo) {
    switch (tipo) {
      case 'electric':
        return const Color(0xFFFFE082);
      case 'fire':
        return const Color(0xFFFFAB91);
      case 'water':
        return const Color(0xFF90CAF9);
      case 'grass':
        return const Color(0xFFA5D6A7);
      case 'poison':
        return const Color(0xFFCE93D8);
      case 'flying':
        return const Color(0xFFB39DDB);
      case 'normal':
        return const Color(0xFFE0E0E0);
      case 'bug':
        return const Color(0xFFDCE775);
      case 'ground':
        return const Color(0xFFD7CCC8);
      case 'ice':
        return const Color(0xFF80DEEA);
      case 'psychic':
        return const Color(0xFFF48FB1);
      case 'fighting':
        return const Color(0xFFEF9A9A);
      case 'rock':
        return const Color(0xFFBCAAA4);
      case 'ghost':
        return const Color(0xFFB39DDB);
      case 'dragon':
        return const Color(0xFF9FA8DA);
      case 'dark':
        return const Color(0xFFA1887F);
      case 'steel':
        return const Color(0xFFB0BEC5);
      case 'fairy':
        return const Color(0xFFF8BBD0);
      default:
        return Colors.grey.shade200;
    }
  }

  Widget _datoPokemon(IconData icono, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icono, size: 30, color: const Color(0xFFC62828)),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
                          return Center(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Color(0xFFC62828),
                                    size: 65,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Error de búsqueda',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC62828),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${snapshot.error}'.replaceFirst(
                                      'Exception: ',
                                      '',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Verifica los datos o tu conexión a internet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        final pokemon = snapshot.data!;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 180,
                                      height: 180,
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5F6FA),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        pokemon.imagen,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '#${pokemon.id.toString().padLeft(3, '0')}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pokemon.nombre.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF263238),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      alignment: WrapAlignment.center,
                                      children: pokemon.tipos.map((tipo) {
                                        return Chip(
                                          label: Text(
                                            tipo.toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF263238),
                                            ),
                                          ),
                                          backgroundColor: _colorTipo(tipo),
                                          side: BorderSide.none,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 12),
                                    const Divider(),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _datoPokemon(
                                            Icons.straighten,
                                            'Altura',
                                            '${pokemon.altura.toStringAsFixed(1)} m',
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _datoPokemon(
                                            Icons.monitor_weight_outlined,
                                            'Peso',
                                            '${pokemon.peso.toStringAsFixed(1)} kg',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Información proporcionada por PokéAPI',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
