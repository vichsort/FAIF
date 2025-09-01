import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:faif/providers/settings_provider.dart';
import '../model/cpf_model.dart';
import '../components/cpf_card.dart';

class CpfScreen extends StatefulWidget {
  const CpfScreen({super.key});

  @override
  State<CpfScreen> createState() => _CpfScreenState();
}

class _CpfScreenState extends State<CpfScreen> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nisController = TextEditingController();

  bool _loading = false;
  Map<String, dynamic>? _dadosPessoa;

  Future<void> buscarPessoa() async {
    final cpf = _cpfController.text.trim();
    final nis = _nisController.text.trim();

    if (cpf.isEmpty || nis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe CPF e NIS.")),
      );
      return;
    }

    setState(() {
      _loading = true;
      _dadosPessoa = null;
    });

    try {
      final url = Uri.parse(
          "http://localhost:5000/faif/transparencia/pessoa-fisica/$cpf&$nis");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _dadosPessoa = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao buscar dados da Pessoa Física.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final fundo = settings.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = settings.isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = settings.isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Consultar CPF',
          style: TextStyle(
            color: texto,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: laranja),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input CPF
            TextField(
              controller: _cpfController,
              style: TextStyle(color: texto),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Digite o CPF',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: fundoInput,
                prefixIcon: const Icon(Icons.badge, color: Colors.grey),
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
            const SizedBox(height: 12),

            // Input NIS
            TextField(
              controller: _nisController,
              style: TextStyle(color: texto),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Digite o NIS',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: fundoInput,
                prefixIcon: const Icon(Icons.numbers, color: Colors.grey),
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
            const SizedBox(height: 16),

            // Botão buscar
            ElevatedButton.icon(
              onPressed: buscarPessoa,
              style: ElevatedButton.styleFrom(
                backgroundColor: laranja,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text("Buscar", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 24),

            // Resultado
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: laranja))
                  : _dadosPessoa == null
                      ? Center(
                          child: Text(
                            "Nenhum dado carregado.",
                            style: TextStyle(color: texto),
                          ),
                        )
                      : ListView(
                          children: [
                            CpfCard(
                              dados: _dadosPessoa!,
                              isDark: true,
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
