import 'package:faif/providers/settings_provider.dart';
import 'package:faif/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // 1. Envolvemos todo o app com o ChangeNotifierProvider.
    // Ele cria uma única instância do SettingsProvider que ficará
    // disponível para toda a árvore de widgets abaixo dele.
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const FaifApp(),
    ),
  );
}

class FaifApp extends StatelessWidget {
  const FaifApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Usamos um Consumer para "ouvir" as mudanças no SettingsProvider.
    // Sempre que o tema for alterado, o MaterialApp será reconstruído
    // com o ThemeMode correto.
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FAIF',
          // 3. O tema do app agora é controlado pelo provider
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // Temas básicos para começar
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),

          home: HomePage(),
        );
      },
    );
  }
}