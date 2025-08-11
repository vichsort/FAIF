import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/deputado_model.dart';
import '../components/deputado_card.dart';
import 'package:faif/screens/config_manual_page.dart';

class DeputadosPage extends StatefulWidget {
  @override
  DeputadosPageState createState() => DeputadosPageState();
}

class DeputadosPageState extends State<DeputadosPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<Deputado> _deputados = [];

  Future<void> buscarDeputados() async {
    setState(() {
      _loading = true;
      _deputados = [];
    });

    final nome = _controller.text.trim();
    final url = Uri.parse('http://localhost:5000/faif/deputados/$nome');
    final response = await http.get(url);

    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _deputados = jsonList.map((e) => Deputado.fromJson(e)).toList();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro na consulta.")));
      }
    });
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
          'Deputados',
          style: TextStyle(
            color: texto,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: texto, fontSize: fontSize),
                    decoration: InputDecoration(
                      hintText: 'Buscar deputado',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: fontSize - 2,
                      ),
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
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: buscarDeputados,
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
                : _deputados.isEmpty
                ? Text(
                    'Nenhum resultado encontrado.',
                    style: TextStyle(color: texto, fontSize: fontSize),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: _deputados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return DeputadoCard(
                          deputado: _deputados[index],
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
