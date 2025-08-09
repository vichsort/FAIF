import 'package:flutter/material.dart';
import '../model/cpf_model.dart';

class CpfCard extends StatelessWidget {
  final CpfConjunto conjunto;
  final double fontSize;
  final bool isDark;

  const CpfCard({
    super.key,
    required this.conjunto,
    required this.fontSize,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.black : Colors.white;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conjunto.titulo.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: fontSize + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            conjunto.descricao,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: fontSize,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "ID: ${conjunto.id}",
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: fontSize - 2,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
