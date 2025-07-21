import 'package:faif/model/emenda_model.dart';
import 'package:flutter/material.dart';

class EmendaCard extends StatelessWidget {
  final EmendaModel emenda;
  const EmendaCard({required this.emenda, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${emenda.titulo} | ${emenda.codigoEmenda}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('${emenda.titularAcao} | Data: ${emenda.data}'),
            const SizedBox(height: 4),
            Text('Autor: ${emenda.nomeAutor} • Tipo: ${emenda.tipoEmenda}'),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () {
                // Navegar para detalhes ou abrir em nova aba
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Acessar'),
            ),
            const SizedBox(height: 4),
            Text(
              'Referência: ${emenda.referencia}',
              style: const TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
