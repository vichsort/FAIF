import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/cgu_model.dart';
import '../components/cgu_card.dart';
import 'config_manual_page.dart';

class CguPage extends StatefulWidget {
  @override
  CguPageState createState() => CguPageState();
}

class CguPageState extends State<CguPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<CguConjunto> _todosConjuntos = [];
  List<CguConjunto> _conjuntosFiltrados = [];

  Future<void> buscarConjuntos() async {
    setState(() {
      _loading = true;
      _todosConjuntos = [];
      _conjuntosFiltrados = [];
    });

    final url = Uri.parse('http://localhost:5000/faif/cgu');
    final response = await http.get(url);

    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _todosConjuntos = jsonList.map((e) => CguConjunto.fromJson(e)).toList();
        _conjuntosFiltrados = List.from(_todosConjuntos);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao buscar dados da CGU.")),
        );
      }
    });
  }

  void filtrarConjuntos() {
    final termo = _controller.text.trim().toLowerCase();
    setState(() {
      if (termo.isEmpty) {
        _conjuntosFiltrados = List.from(_todosConjuntos);
      } else {
        _conjuntosFiltrados = _todosConjuntos
            .where((c) => c.titulo.toLowerCase().contains(termo))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    buscarConjuntos();
  }

  @override
  Widget build(BuildContext context) {
    final fundo = isDarkMode ? Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final laranja = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: laranja),
        title: Text(
          'Dados CGU',
          style: TextStyle(
            color: texto,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: texto, fontSize: fontSize),
                    decoration: InputDecoration(
                      hintText: 'Buscar por título',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize - 2),
                      filled: true,
                      fillColor: fundoInput,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: laranja, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: laranja, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => filtrarConjuntos(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: filtrarConjuntos,
                  icon: Icon(Icons.search),
                  color: laranja,
                  tooltip: 'Buscar',
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(fundoInput),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _loading
                ? CircularProgressIndicator(color: laranja)
                : _conjuntosFiltrados.isEmpty
                    ? Text(
                        'Nenhum conjunto encontrado.',
                        style: TextStyle(color: texto, fontSize: fontSize),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _conjuntosFiltrados.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CguCard(
                                conjunto: _conjuntosFiltrados[index],
                                fontSize: fontSize,
                                isDark: isDarkMode,
                              ),
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
