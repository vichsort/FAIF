import 'package:flutter/material.dart';

bool isDarkMode = false;
double fontSize = 16;

class ConfigManualPage extends StatefulWidget {
  const ConfigManualPage({super.key});

  @override
  State<ConfigManualPage> createState() => _ConfigManualPageState();
}

class _ConfigManualPageState extends State<ConfigManualPage> {
  @override
  Widget build(BuildContext context) {
    // Cores conforme o tema
    final Color fundo = isDarkMode ? Colors.black : Colors.white;
    final Color texto = isDarkMode ? Colors.white : Colors.black;
    final Color corSwitch = Colors.blue;
    final Color corSlider = Colors.orange;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        title: Text(
          'Configurações',
          style: TextStyle(color: texto, fontSize: fontSize),
        ),
        iconTheme: IconThemeData(color: texto),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tamanho da fonte', style: TextStyle(fontSize: fontSize, color: texto)),
            Slider(
              value: fontSize,
              min: 12,
              max: 24,
              divisions: 6,
              label: '${fontSize.round()}',
              activeColor: corSlider,
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text('Modo', style: TextStyle(fontSize: fontSize, color: texto)),
            SwitchListTile(
              title: Text(
                isDarkMode ? 'Escuro' : 'Claro',
                style: TextStyle(fontSize: fontSize, color: texto),
              ),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              activeColor: corSwitch,
              inactiveTrackColor: Colors.grey,
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'As alterações serão aplicadas em todas as telas',
                style: TextStyle(fontSize: fontSize - 2, color: texto.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
