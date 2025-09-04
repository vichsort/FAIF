import 'package:faif/components/cnpj_card.dart';
import 'package:faif/model/cnpj_model.dart';
import 'package:faif/providers/settings_provider.dart';
import 'package:faif/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaCnpjPage extends StatefulWidget {
  @override
  _ConsultaCnpjPageState createState() => _ConsultaCnpjPageState();
}

class _ConsultaCnpjPageState extends State<ConsultaCnpjPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();

  bool _loading = false;
  CnpjModel? _dados;
  String? _erro;

  Future<void> consultarCnpj() async {
    final cnpj = _controller.text.trim();
    if (cnpj.isEmpty) {
      setState(() => _erro = 'Por favor, informe um CNPJ.');
      return;
    }

    setState(() {
      _loading = true;
      _dados = null;
      _erro = null;
    });

    try {
      final result = await _apiService.fetchCnpj(cnpj);
      setState(() {
        _dados = result;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
    final fundoInput = settings.isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.grey[200]!;
    final texto = settings.isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);
    final fontSize = settings.fontSize;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        iconTheme: IconThemeData(color: laranja),
        title: Text(
          'Consultar CNPJ',
          style: TextStyle(
            color: texto,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
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
                        hintText: "Digite o CNPJ...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => consultarCnpj(),
                    ),
                  ),
                  IconButton(
                    onPressed: _loading ? null : consultarCnpj,
                    icon: Icon(Icons.search, color: laranja, size: 26),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildResultView(settings)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(SettingsProvider settings) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: const Color(0xFFFF6B35)),
      );
    }

    if (_erro != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: settings.isDarkMode
              ? const Color(0xFF2B1B16)
              : const Color(0xFFFFE9E1),
          border: Border.all(color: const Color(0xFFFF6B35), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _erro!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: settings.isDarkMode ? Colors.white : Colors.black,
            fontSize: settings.fontSize,
          ),
        ),
      );
    }

    if (_dados != null) {
      return CnpjCard(
        cnpj: _dados!,
        isDark: settings.isDarkMode,
        fontSize: settings.fontSize,
      );
    }

    return Center(
      child: Text(
        'Digite um CNPJ para iniciar a consulta.',
        style: TextStyle(
          color: settings.isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}
