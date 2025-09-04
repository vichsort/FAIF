import 'package:flutter/material.dart';
import 'package:faif/model/cnpj_model.dart';

class CnpjCard extends StatelessWidget {
  final CnpjModel cnpj;
  final bool isDark;
  final double fontSize;

  const CnpjCard({
    super.key,
    required this.cnpj,
    required this.isDark,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final fundoCard = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textoPrincipal = isDark ? Colors.white : Colors.black87;
    final textoSecundario = isDark ? Colors.white70 : Colors.black54;
    final corDestaque = const Color(0xFFFF6B35);

    return Card(
      color: fundoCard,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(textoPrincipal, textoSecundario),
            _buildSectionDivider(),
            _buildSectionTitle('Informações Gerais', corDestaque),
            _buildInfoRow('CNPJ:', cnpj.cnpj, textoPrincipal, textoSecundario),
            _buildInfoRow(
              'Abertura:',
              cnpj.dataInicioAtividade,
              textoPrincipal,
              textoSecundario,
            ),
            _buildInfoRow(
              'Porte:',
              cnpj.porte,
              textoPrincipal,
              textoSecundario,
            ),
            _buildInfoRow(
              'Natureza Jurídica:',
              cnpj.naturezaJuridica,
              textoPrincipal,
              textoSecundario,
            ),
            _buildSectionDivider(),
            _buildSectionTitle('Endereço', corDestaque),
            Text(
              '${cnpj.logradouro}, ${cnpj.numero} - ${cnpj.complemento}\n${cnpj.bairro}, ${cnpj.municipio} - ${cnpj.uf}, ${cnpj.cep}',
              style: TextStyle(color: textoPrincipal, fontSize: fontSize - 2),
            ),
            if (cnpj.atividadePrincipal != null) ...[
              _buildSectionDivider(),
              _buildSectionTitle('Atividade Principal (CNAE)', corDestaque),
              Text(
                '${cnpj.atividadePrincipal!.code} - ${cnpj.atividadePrincipal!.text}',
                style: TextStyle(color: textoPrincipal, fontSize: fontSize - 2),
              ),
            ],
            if (cnpj.cnaesSecundarios.isNotEmpty) ...[
              _buildSectionDivider(),
              _buildSectionTitle('Atividades Secundárias', corDestaque),
              ...cnpj.cnaesSecundarios.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '• ${a.text}',
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: fontSize - 2,
                    ),
                  ),
                ),
              ),
            ],
            if (cnpj.qsa.isNotEmpty) ...[
              _buildSectionDivider(),
              _buildSectionTitle(
                'Quadro de Sócios e Administradores (QSA)',
                corDestaque,
              ),
              ...cnpj.qsa.map(
                (s) => _buildInfoRow(
                  '${s.qual}:',
                  s.nome,
                  textoPrincipal,
                  textoSecundario,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textoPrincipal, Color textoSecundario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                cnpj.razaoSocial,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: textoPrincipal,
                ),
              ),
            ),
            SizedBox(width: 8),
            _buildStatusChip(cnpj.situacao),
          ],
        ),
        if (cnpj.nomeFantasia.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              cnpj.nomeFantasia,
              style: TextStyle(
                fontSize: fontSize - 2,
                color: textoSecundario,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: fontSize - 4,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Divider(height: 24, color: Colors.grey.withAlpha(240));
  }

  Widget _buildStatusChip(String status) {
    final bool isAtiva = status.toUpperCase() == 'ATIVA';
    final Color chipColor = isAtiva
        ? Colors.green.shade700
        : Colors.red.shade700;
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

  Widget _buildInfoRow(
    String title,
    String value,
    Color textColor,
    Color labelColor,
  ) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize - 2,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
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
}
