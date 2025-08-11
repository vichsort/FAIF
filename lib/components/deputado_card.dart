import 'package:flutter/material.dart';
import '../model/deputado_model.dart';

class DeputadoCard extends StatelessWidget {
  final Deputado deputado;
  final double fontSize;
  final bool isDark;

  const DeputadoCard({
    super.key,
    required this.deputado,
    required this.fontSize,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fundo = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final texto = isDark ? Colors.white : Colors.black87;
    final laranja = const Color(0xFFFF6B35);

    return Container(
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: laranja, width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              deputado.urlFoto,
              height: 120,
              width: 96,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deputado.nome,
                  style: TextStyle(
                    color: texto,
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _linha('Partido', deputado.siglaPartido, texto),
                _linha('UF', deputado.siglaUf, texto),
                if (deputado.email.isNotEmpty)
                  _linha('Email', deputado.email, texto),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha(String titulo, String valor, Color color) {
    if (valor.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: color, fontSize: fontSize - 2),
          children: [
            TextSpan(
              text: '$titulo: ',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            TextSpan(
              text: valor,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
