import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/deputado_model.dart';
import '../components/deputado_card.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro na consulta.")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A), // preto uniforme
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A), // mesmo tom da tela
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFFF6B35)),
        title: Text(
          'Deputados',
          style: TextStyle(
            color: Colors.white, // destaque em laranja
            fontSize: 22,
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar deputado',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2), // borda laranja
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2), // borda laranja
                      ),
                    ),
                  ),

                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: buscarDeputados,
                  icon: Icon(Icons.search),
                  color: Color(0xFFFF6B35),
                  tooltip: 'Buscar',
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Color(0xFF2A2A2A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _loading
                ? CircularProgressIndicator(color: Color(0xFFFF6B35))
                : _deputados.isEmpty
                    ? Text(
                        'Nenhum resultado encontrado.',
                        style: TextStyle(color: Colors.white),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _deputados.length,
                          itemBuilder: (context, index) {
                            return DeputadoCard(deputado: _deputados[index]);
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}