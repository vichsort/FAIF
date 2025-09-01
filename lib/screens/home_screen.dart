import 'package:faif/providers/settings_provider.dart';
import 'package:faif/screens/cnpj_screen.dart';
import 'package:faif/screens/config_screen.dart';
import 'package:faif/screens/deputado_screen.dart';
import 'package:faif/screens/emendas_parlamentares.dart';
import 'package:faif/screens/ibge_screen.dart';
import 'package:faif/screens/busca_unificada_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // 1. Acessa o provider para obter as configurações atuais
    final settings = Provider.of<SettingsProvider>(context);

    // 2. As variáveis de UI são definidas com base nos valores do provider
    final fundo = settings.isDarkMode ? Color(0xFF1A1A1A) : Colors.white;
    final texto = settings.isDarkMode ? Colors.white : Colors.black;
    final destaque = Color(0xFFFF6B35);
    final fundoCard = settings.isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFF0F0F0);
    final textoSecundario = settings.isDarkMode ? Colors.white70 : Colors.black54;
    final fontSize = settings.fontSize;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Image.asset('assets/logo.png'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GridView.extent(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              maxCrossAxisExtent: 140,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.9,
              children: [
                _buildServiceIcon(context, Icons.people_outline, 'Deputados', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DeputadosPage()));
                }),
                _buildServiceIcon(context, Icons.trending_up, 'Emendas\nParlamentares', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EmendasPage(emendas: [])));
                }),
                _buildServiceIcon(context, Icons.business_center_outlined, 'Consultar\nCNPJ', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultaCnpjPage()));
                }),
                _buildServiceIcon(context, Icons.account_balance_outlined, 'Pesquisas\nIBGE', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => IBGEScreen()));
                }),
              ],
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BuscaUnificadaPage()));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(color: destaque, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'A Ferramenta\nde pesquisa.',
                            style: TextStyle(color: Colors.white, fontSize: fontSize + 8, fontWeight: FontWeight.bold, height: 1.2),
                          ),
                        ),
                        Icon(Icons.edit_outlined, color: Colors.white, size: fontSize + 4),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.search, color: Colors.white70, size: fontSize),
                        SizedBox(width: 8),
                        Expanded(child: Text('Encontre qualquer informação, tudo num só lugar', style: TextStyle(color: Colors.white70, fontSize: fontSize - 2))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildBottomCard(context, 'Histórico', 'Suas pesquisas salvas aqui.', Icons.history_outlined, () => _showNotImplemented(context)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildBottomCard(context, 'Configurações', 'Deixe o app do seu jeito', Icons.settings_outlined, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfigScreen()));
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final settings = Provider.of<SettingsProvider>(context, listen: false); // listen: false pois não muda dinamicamente aqui
    final fundoCard = settings.isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFF0F0F0);
    final destaque = Color(0xFFFF6B35);
    final texto = settings.isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: fundoCard, shape: BoxShape.circle),
            child: Icon(icon, color: destaque, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: texto, fontSize: 13, height: 1.2, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final fundoCard = settings.isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFF0F0F0);
    final texto = settings.isDarkMode ? Colors.white : Colors.black;
    final textoSecundario = settings.isDarkMode ? Colors.white70 : Colors.black54;
    final destaque = Color(0xFFFF6B35);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: fundoCard, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: texto, fontSize: settings.fontSize, fontWeight: FontWeight.w600)),
                Icon(Icons.open_in_new_outlined, color: textoSecundario, size: settings.fontSize),
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: textoSecundario, fontSize: settings.fontSize - 2)),
            ],
            SizedBox(height: 12),
            Icon(icon, color: destaque, size: settings.fontSize + 6),
          ],
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Funcionalidade ainda não implementada', style: TextStyle(fontSize: settings.fontSize - 2)),
        backgroundColor: Color(0xFFFF6B35),
      ),
    );
  }
}