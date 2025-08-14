import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/ibge_model.dart';
import '../components/ibge_card.dart';
import 'package:faif/screens/config_manual_page.dart';

class IBGEScreen extends StatefulWidget {
  @override
  State<IBGEScreen> createState() => _IBGEScreenState();
}

class _IBGEScreenState extends State<IBGEScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<PesquisaIBGE> _pesquisas = [];

  Future<void> buscarPesquisas() async {
    setState(() {
      _loading = true;
      _pesquisas = [];
    });

    final termo = _controller.text.trim();
    final url = Uri.parse('https://servicodados.ibge.gov.br/api/v2/metadados/Pesquisa?q=$termo');

    final response = await http.get(url);

    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _pesquisas = jsonList.map((e) => PesquisaIBGE.fromJson(e)).toList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro na consulta")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundo = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        title: Text('IBGE - Pesquisas', style: TextStyle(color: texto)),
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
                    style: TextStyle(color: texto),
                    decoration: InputDecoration(
                      hintText: 'Buscar pesquisa',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: fundoInput,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: buscarPesquisas,
                  icon: Icon(Icons.search),
                  color: laranja,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _loading
                ? CircularProgressIndicator(color: laranja)
                : _pesquisas.isEmpty
                    ? Text('Nenhum resultado', style: TextStyle(color: texto))
                    : Expanded(
                        child: ListView.separated(
                          itemCount: _pesquisas.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return IBGECard(
                              pesquisa: _pesquisas[index],
                              fontSize: 16,
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