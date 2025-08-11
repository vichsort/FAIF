import 'package:faif/screens/cgu_screen.dart';
import 'package:faif/screens/emendas_parlamentares.dart';
import 'package:flutter/material.dart';
import 'package:faif/screens/cnpj_screen.dart';
import 'package:faif/screens/deputado_screen.dart';
import 'package:faif/screens/config_manual_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final fundo = isDarkMode ? Color(0xFF1A1A1A) : Colors.white;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final destaque = Color(0xFFFF6B35);
    final fundoCard = isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[200]!;
    final textoSecundario = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: destaque,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/logo.png'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildServiceIcon(context, Icons.people, 'Deputados', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DeputadosPage()),
                  );
                }),
                _buildServiceIcon(context, Icons.person, 'Consultar\nCPF', () {
                  _showNotImplemented(context);
                }),
                _buildServiceIcon(
                  context,
                  Icons.business,
                  'Consultar\nCNPJ',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ConsultaCnpjPage()),
                    );
                  },
                ),
                _buildServiceIcon(
                  context,
                  Icons.account_balance,
                  'Estruturas\nExecutivo',
                  () {
                    _showNotImplemented(context);
                  },
                ),
                _buildServiceIcon(
                  context,
                  Icons.groups,
                  'Servidores\nExecutivo',
                  () {
                    _showNotImplemented(context);
                  },
                ),
                _buildServiceIcon(context, Icons.monetization_on, 'COFIEX', () {
                  _showNotImplemented(context);
                }),
                _buildServiceIcon(
                  context,
                  Icons.trending_up,
                  'Emendas\nParlamentares',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmendasPage(emendas: []),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(context, Icons.security, 'CGU', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CguPage()),
                  );
                }),
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: destaque,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'A Ferramenta\nde pesquisa.',
                          style: TextStyle(
                            color: texto,
                            fontSize: fontSize + 8,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Icon(Icons.edit, color: texto, size: fontSize + 4),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: textoSecundario,
                        size: fontSize,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Encontre qualquer informação, tudo num só lugar',
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: fontSize - 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildBottomCard(
                    'Histórico',
                    'Suas pesquisas salvas aqui.',
                    Icons.history,
                    () => _showNotImplemented(context),
                    fundoCard,
                    texto,
                    textoSecundario,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildBottomCard(
                    'Configurações',
                    'Deixe o app do seu jeito',
                    Icons.settings,
                    () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConfigManualPage(),
                          ),
                        ).then((_) {
                          setState(
                            () {},
                          ); // Isso força a HomePage a se reconstruir com os novos valores
                        }),

                    fundoCard,
                    texto,
                    textoSecundario,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: fontSize + 4),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: fontSize - 4,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    Color bgColor,
    Color titleColor,
    Color subtitleColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  color: subtitleColor,
                  size: fontSize - 2,
                ),
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: subtitleColor, fontSize: fontSize - 2),
              ),
            ],
            SizedBox(height: 12),
            Icon(icon, color: subtitleColor, size: fontSize + 2),
          ],
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Funcionalidade ainda não implementada',
          style: TextStyle(fontSize: fontSize),
        ),
        backgroundColor: Color(0xFFFF6B35),
      ),
    );
  }
}
