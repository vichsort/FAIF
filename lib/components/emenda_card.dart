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
    final fundoCard = isDark ? Color(0xFF2A2A2A) : Colors.grey[100];
    final textoPrincipal = isDark ? Colors.white : Colors.black87;
    final textoSecundario = isDark ? Colors.white70 : Colors.black54;
    final corDestaque = const Color(0xFFFF6B35);

    return Card(
      color: fundoCard,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CABEÇALHO ---
            Text(
              emenda.autor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: textoPrincipal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              'Ano: ${emenda.ano} • Emenda N° ${emenda.numeroEmenda}',
              style: TextStyle(
                fontSize: fontSize - 3,
                color: textoSecundario,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(height: 24, color: textoSecundario.withAlpha(240)),

            // --- DETALHES ---
            _buildInfoRow('Tipo:', emenda.tipoEmenda, fontSize, textoPrincipal, textoSecundario),
            _buildInfoRow('Função:', emenda.funcao, fontSize, textoPrincipal, textoSecundario),
            _buildInfoRow('Localidade:', emenda.localidadeDoGasto, fontSize, textoPrincipal, textoSecundario),
            SizedBox(height: 12),

            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildValueChip('Empenhado', emenda.valorEmpenhado, Colors.blue, fontSize),
                _buildValueChip('Pago', emenda.valorPago, corDestaque, fontSize),
              ],
            ),
            SizedBox(height: 12),
            
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Fonte: Portal da Transparência',
                style: TextStyle(
                  fontSize: fontSize - 4,
                  fontStyle: FontStyle.italic,
                  color: textoSecundario,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar linhas de informação padronizadas
  Widget _buildInfoRow(String title, String value, double fontSize, Color textColor, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize - 2, color: labelColor, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize - 2, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para exibir os valores em destaque
  Widget _buildValueChip(String label, String value, Color color, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: fontSize - 3, color: Colors.grey[500], fontWeight: FontWeight.bold),
        ),
        Text(
          'R\$ $value',
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}