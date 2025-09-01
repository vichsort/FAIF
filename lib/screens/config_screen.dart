import 'package:faif/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// As variáveis globais foram removidas. O estado agora vive no SettingsProvider.

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Usamos um Consumer para ter acesso ao provider.
    // Ele reconstrói a UI automaticamente quando os valores em `settings` mudam.
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        
        // Cores e fontes são lidas diretamente do `settings` do provider
        final Color fundo = settings.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
        final Color texto = settings.isDarkMode ? Colors.white : Colors.black;
        final double fontSize = settings.fontSize;

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
                  value: fontSize, // Lendo o valor do provider
                  min: 12,
                  max: 24,
                  divisions: 6,
                  label: '${fontSize.round()}',
                  activeColor: const Color(0xFFFF6B35),
                  onChanged: (value) {
                    // 2. Ao mudar, chamamos o método do provider para ATUALIZAR o estado.
                    // Usamos 'listen: false' porque estamos dentro de um callback,
                    // a atualização da UI será feita pelo Consumer.
                    Provider.of<SettingsProvider>(context, listen: false).setFontSize(value);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(
                    'Modo Escuro',
                    style: TextStyle(fontSize: fontSize, color: texto),
                  ),
                  value: settings.isDarkMode, // Lendo o valor do provider
                  onChanged: (value) {
                    // 3. Mesma lógica para o switch: chamamos o método do provider.
                    Provider.of<SettingsProvider>(context, listen: false).toggleTheme(value);
                  },
                  activeColor: const Color(0xFFFF6B35),
                  inactiveTrackColor: Colors.grey[300],
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'As alterações serão aplicadas em todas as telas',
                    style: TextStyle(fontSize: fontSize - 4, color: texto.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}