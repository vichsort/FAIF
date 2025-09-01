import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/deputado_model.dart';
import '../components/deputado_card.dart';
import 'package:faif/screens/config_screen.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fundo = isDarkMode ? const Color(0xFF0F1115) : Colors.white;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deputados",
                style: TextStyle(
                  color: texto,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1F23) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: laranja, width: 2),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/logo.png", width: 28, height: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: texto, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Pesquisa...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: buscarDeputados,
                      icon: Icon(Icons.search, color: laranja, size: 26),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // resultados
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator(color: laranja))
                    : _deputados.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum resultado encontrado.',
                          style: TextStyle(color: texto, fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _deputados.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return DeputadoCard(
                            deputado: _deputados[index],
                            isDark: isDarkMode,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
