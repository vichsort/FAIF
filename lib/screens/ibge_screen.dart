import 'package:faif/services/api_service.dart';
import 'package:flutter/material.dart';
import '../model/ibge_model.dart';
import '../components/ibge_card.dart';
import 'package:faif/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class IBGEScreen extends StatefulWidget {
  @override
  State<IBGEScreen> createState() => _IBGEScreenState();
}

class _IBGEScreenState extends State<IBGEScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();

  bool _loading = false;
  String? _error;
  List<PesquisaIBGE> _pesquisas = [];

  Future<void> buscarPesquisas() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final termo = _controller.text.trim();

    try {
      final result = await _apiService.fetchIbge(termo.isNotEmpty ? termo : null);
      setState(() {
        _pesquisas = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _pesquisas = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    buscarPesquisas();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final fundo = settings.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = settings.isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = settings.isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);
    final fontSize = settings.fontSize;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        iconTheme: IconThemeData(color: laranja),
        title: Text('Pesquisas IBGE', style: TextStyle(color: texto, fontSize: fontSize, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: fundoInput,
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
                        hintText: "Pesquisar por nome ou tema...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => buscarPesquisas(),
                    ),
                  ),
                  IconButton(
                    onPressed: _loading ? null : buscarPesquisas,
                    icon: Icon(Icons.search, color: laranja, size: 26),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- ÁREA DE RESULTADOS ---
            Expanded(
              child: _buildResultView(settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(SettingsProvider settings) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: const Color(0xFFFF6B35)));
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[400], fontSize: settings.fontSize),
          ),
        ),
      );
    }
    
    if (_pesquisas.isEmpty) {
      return Center(
        child: Text(
          'Nenhum resultado encontrado.',
          style: TextStyle(color: settings.isDarkMode ? Colors.white70 : Colors.black54, fontSize: settings.fontSize),
        ),
      );
    }

    return ListView.builder(
      itemCount: _pesquisas.length,
      itemBuilder: (context, index) {
        return IBGECard(
          pesquisa: _pesquisas[index],
          fontSize: settings.fontSize,
          isDark: settings.isDarkMode,
        );
      },
    );
  }
}