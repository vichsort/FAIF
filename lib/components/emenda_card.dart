import 'package:flutter/material.dart';
import 'package:faif/model/emenda_model.dart';

class EmendaCard extends StatelessWidget {
  final EmendaModel emenda;
  final double fontSize;
  final bool isDark;

  const EmendaCard({
    required this.emenda,
    required this.fontSize,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texto = isDark ? Colors.white : Colors.black;

    return Card(
      color: isDark ? Color(0xFF2A2A2A) : Colors.grey[200],
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${emenda.titulo} | ${emenda.codigoEmenda}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: texto)),
            SizedBox(height: 4),
            Text('${emenda.titularAcao} | Data: ${emenda.data}',
                style: TextStyle(fontSize: fontSize - 1, color: texto)),
            SizedBox(height: 4),
            Text('Autor: ${emenda.nomeAutor} • Tipo: ${emenda.tipoEmenda}',
                style: TextStyle(fontSize: fontSize - 1, color: texto)),
            SizedBox(height: 6),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Acessar', style: TextStyle(fontSize: fontSize)),
            ),
            SizedBox(height: 4),
            Text('Referência: ${emenda.referencia}',
                style: TextStyle(fontSize: fontSize - 2, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}