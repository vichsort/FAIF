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

  void _launchURL(BuildContext context) async {
    final String nomeDaPesquisa = pesquisa.nome;
    final String query = Uri.encodeComponent(nomeDaPesquisa);

    final url = Uri.parse(
      'https://www.ibge.gov.br/busca.html?searchword=$query',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível abrir o link: ${url.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fundo = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final texto = isDark ? Colors.white : Colors.black87;
    final textoSecundario = isDark ? Colors.white70 : Colors.black54;
    final laranja = const Color(0xFFFF6B35);

    return Card(
      color: fundo,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withAlpha(240), width: 1),
      ),
      child: InkWell(
        onTap: () => _launchURL(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      pesquisa.nome,
                      style: TextStyle(
                        color: texto,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildStatusChip(pesquisa.situacao),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${pesquisa.categoria} • Divulgação ${pesquisa.periodicidadeDivulgacao}',
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: fontSize - 3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (pesquisa.classificacoesTematicas.isNotEmpty) ...[
                Divider(height: 24, color: textoSecundario.withOpacity(0.2)),
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: pesquisa.classificacoesTematicas.map((tema) {
                    return Chip(
                      label: Text(tema.nome),
                      labelStyle: TextStyle(
                        fontSize: fontSize - 4,
                        color: texto,
                      ),
                      backgroundColor: laranja.withOpacity(isDark ? 0.3 : 0.1),
                      side: BorderSide(color: laranja.withOpacity(0.5)),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final bool isAtiva = status.toLowerCase() == 'ativa';
    final Color chipColor = isAtiva
        ? Colors.green.shade700
        : Colors.grey.shade600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
