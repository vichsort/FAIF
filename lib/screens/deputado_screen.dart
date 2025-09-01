import 'package:faif/services/api_service.dart';
import 'package:flutter/material.dart';
import '../model/deputado_model.dart';
import '../components/deputado_card.dart';

class DeputadosPage extends StatefulWidget {
  @override
  DeputadosPageState createState() => DeputadosPageState();
}

class DeputadosPageState extends State<DeputadosPage> {
  final ApiService _apiService = ApiService(); 
  final TextEditingController _controller = TextEditingController();
  
  bool _loading = false;
  String? _error;
  List<Deputado> _deputados = [];

  Future<void> buscarDeputados() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }
    
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final deputadosEncontrados = await _apiService.fetchDeputados(_controller.text.trim());
      setState(() {
        _deputados = deputadosEncontrados;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', ''); 
        _deputados = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
              Text("Deputados", style: TextStyle(color: texto, fontSize: 28, fontWeight: FontWeight.bold)),
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
                          hintText: "Pesquisar por nome...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => buscarDeputados(),
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
              Expanded(
                child: _buildResultView(texto, laranja),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView(Color textColor, Color highlightColor) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: highlightColor));
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red[400], fontSize: 16),
        ),
      );
    }

    if (_deputados.isEmpty) {
      return Center(
        child: Text(
          'Nenhum resultado encontrado.',
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      itemCount: _deputados.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return DeputadoCard(
          deputado: _deputados[index],
          isDark: isDarkMode,
        );
      },
    );
  }
}