import 'package:flutter/material.dart';
import '../model/ibge_model.dart';
import 'package:url_launcher/url_launcher.dart';

class IBGECard extends StatelessWidget {
  final PesquisaIBGE pesquisa;
  final double fontSize;
  final bool isDark;

  const IBGECard({
    super.key,
    required this.pesquisa,
    required this.fontSize,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fundo = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final texto = isDark ? Colors.white : Colors.black87;
    final laranja = const Color(0xFFFF6B35);

    return GestureDetector(
      onTap: () async {
        final url = 'https://www.ibge.gov.br/estatisticas/${pesquisa.codigo}';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível abrir o link')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: laranja, width: 1.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pesquisa.nome,
              style: TextStyle(
                  color: texto,
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Categoria: ${pesquisa.categoria}', style: TextStyle(color: texto, fontSize: fontSize - 2)),
            if (pesquisa.classificacoesTematicas.isNotEmpty)
              Text(
                'Temas: ${pesquisa.classificacoesTematicas.map((e) => e.nome).join(', ')}',
                style: TextStyle(color: texto, fontSize: fontSize - 2),
              ),
          ],
        ),
      ),
    );
  }
}