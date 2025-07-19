import '../screens/cnpj_screen.dart';
import '../screens/deputado_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xFFFF6B35),
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
            // Grid de serviços
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildServiceIcon(
                  context,
                  Icons.people,
                  'Deputados',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeputadosPage()),
                  ),
                ),
                _buildServiceIcon(
                  context,
                  Icons.person,
                  'Consultar\nCPF',
                  () => _showNotImplemented(context),
                ),
                _buildServiceIcon(
                  context,
                  Icons.business,
                  'Consultar\nCNPJ',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CnpjPage()),
                  ),
                ),
                _buildServiceIcon(
                  context,
                  Icons.account_balance,
                  'Estruturas\nExecutivo',
                  () => _showNotImplemented(context),
                ),
                _buildServiceIcon(
                  context,
                  Icons.groups,
                  'Servidores\nExecutivo',
                  () => _showNotImplemented(context),
                ),
                _buildServiceIcon(
                  context,
                  Icons.monetization_on,
                  'COFIEX',
                  () => _showNotImplemented(context),
                ),
                _buildServiceIcon(
                  context,
                  Icons.trending_up,
                  'Portal Da\nTransparência',
                  () => _showNotImplemented(context),
                ),
                _buildServiceIcon(
                  context,
                  Icons.security,
                  'CGU',
                  () => _showNotImplemented(context),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Card principal de pesquisa
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFFF6B35),
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
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Icon(Icons.edit, color: Colors.white, size: 24),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.search, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Encontre qualquer informação, tudo num só lugar',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Cards inferiores
            Row(
              children: [
                Expanded(
                  child: _buildBottomCard(
                    'Histórico',
                    'Suas pesquisas salvas aqui.',
                    Icons.history,
                    () => _showNotImplemented(context),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildBottomCard(
                    'Configurações',
                    '',
                    Icons.settings,
                    () => _showNotImplemented(context),
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
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.2),
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
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
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
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.open_in_new, color: Colors.white70, size: 16),
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
            SizedBox(height: 12),
            Icon(icon, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Funcionalidade ainda não implementada'),
        backgroundColor: Color(0xFFFF6B35),
      ),
    );
  }
}
