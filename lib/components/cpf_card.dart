import 'package:flutter/material.dart';

class CpfCard extends StatelessWidget {
  final Map<String, dynamic> dados;
  final bool isDark;

  const CpfCard({super.key, required this.dados, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final accent = const Color(0xFFFF6B35);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: accent, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome
          Text(
            dados['nome']?.toString().toUpperCase() ?? "NOME NÃO INFORMADO",
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // CPF
          Row(
            children: [
              Icon(Icons.badge, size: 18, color: accent),
              const SizedBox(width: 8),
              Text(
                "CPF: ${dados['cpf'] ?? '-'}",
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // NIS
          Row(
            children: [
              Icon(Icons.numbers, size: 18, color: accent),
              const SizedBox(width: 8),
              Text(
                "NIS: ${dados['nis'] ?? '-'}",
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Situação / Extra
          if (dados.containsKey('situacao')) ...[
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: accent),
                const SizedBox(width: 8),
                Text(
                  "Situação: ${dados['situacao']}",
                  style: TextStyle(
                    color: textColor.withOpacity(0.9),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
