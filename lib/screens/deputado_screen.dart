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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro na consulta.")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Deputados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome do deputado',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: buscarDeputados, child: Text('Buscar')),
            const SizedBox(height: 24),
            _loading
                ? CircularProgressIndicator()
                : _deputados.isEmpty
                ? Text('Nenhum resultado encontrado.')
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
