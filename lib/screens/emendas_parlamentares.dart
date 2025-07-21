import 'package:faif/components/emenda_card.dart';
import 'package:faif/model/emenda_model.dart';
import 'package:flutter/material.dart';

class EmendasPage extends StatelessWidget {
  final List<EmendaModel> emendas;

  const EmendasPage({required this.emendas, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emendas Parlamentares')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar autor, tipo, ano...',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // Filtrar resultados conforme necessário
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: emendas.length,
              itemBuilder: (context, index) {
                return EmendaCard(emenda: emendas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
