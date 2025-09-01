import 'package:faif/providers/settings_provider.dart';
import 'package:faif/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
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
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FAIF',
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

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
