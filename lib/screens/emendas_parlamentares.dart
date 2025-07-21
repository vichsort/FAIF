import 'package:flutter/material.dart';
import 'package:faif/model/emenda_model.dart';
import 'package:faif/components/emenda_card.dart';
import 'package:faif/screens/config_manual_page.dart';

class EmendasPage extends StatefulWidget {
  final List<EmendaModel> emendas;

  const EmendasPage({required this.emendas, super.key});

  @override
  State<EmendasPage> createState() => _EmendasPageState();
}

class _EmendasPageState extends State<EmendasPage> {
  String autorQuery = '';
  String tipoQuery = '';
  String anoQuery = '';

  @override
  Widget build(BuildContext context) {
    final fundo = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);

    List<EmendaModel> emendasFiltradas = widget.emendas.where((e) {
      final autorOK = autorQuery.isEmpty || e.nomeAutor.toLowerCase().contains(autorQuery.toLowerCase());
      final tipoOK = tipoQuery.isEmpty || e.tipoEmenda.toLowerCase().contains(tipoQuery.toLowerCase());
      final anoOK = anoQuery.isEmpty || e.ano.toString() == anoQuery;
      return autorOK && tipoOK && anoOK;
    }).toList();

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        iconTheme: IconThemeData(color: laranja),
        title: Text(
          'Emendas Parlamentares',
          style: TextStyle(
            color: texto,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Campo: Autor
            TextField(
              onChanged: (value) => autorQuery = value,
              style: TextStyle(color: texto, fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Filtrar por autor',
                labelStyle: TextStyle(color: texto),
                filled: true,
                fillColor: fundoInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: laranja),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Campo: Tipo
            TextField(
              onChanged: (value) => tipoQuery = value,
              style: TextStyle(color: texto, fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Filtrar por tipo',
                labelStyle: TextStyle(color: texto),
                filled: true,
                fillColor: fundoInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: laranja),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Campo: Ano
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => anoQuery = value,
              style: TextStyle(color: texto, fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Filtrar por ano',
                labelStyle: TextStyle(color: texto),
                filled: true,
                fillColor: fundoInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: laranja),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botão de pesquisa
            ElevatedButton.icon(
              onPressed: () => setState(() {}),
              icon: Icon(Icons.search, size: fontSize, color: Colors.white),
              label: Text('Pesquisar', style: TextStyle(fontSize: fontSize, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: laranja,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de cards
            Expanded(
              child: emendasFiltradas.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma emenda encontrada.',
                        style: TextStyle(color: texto, fontSize: fontSize),
                      ),
                    )
                  : ListView.builder(
                      itemCount: emendasFiltradas.length,
                      itemBuilder: (context, index) {
                        return EmendaCard(
                          emenda: emendasFiltradas[index],
                          fontSize: fontSize,
                          isDark: isDarkMode,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}