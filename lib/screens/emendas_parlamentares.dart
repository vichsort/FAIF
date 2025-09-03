import 'package:faif/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:faif/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:faif/model/emenda_model.dart';
import 'package:faif/components/emenda_card.dart';

class EmendasPage extends StatefulWidget {
  const EmendasPage({super.key});

  @override
  State<EmendasPage> createState() => _EmendasPageState();
}

class _EmendasPageState extends State<EmendasPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();

  String _tipoQuery = '';
  bool _loading = false;
  String? _error; 
  int _page = 1;
  List<EmendaModel> _emendas = [];

  final List<String> tiposDisponiveis = [
    'Todos', 'Individual', 'De bancada', 'De comissão', 'De relator'
  ];

  Future<void> _buscarEmendas({int? page}) async {
    setState(() {
      _loading = true;
      _error = null; 
      if (page != null) _page = page;
    });

    final params = <String, String>{};
    if (_autorController.text.trim().isNotEmpty) params['nomeAutor'] = _autorController.text.trim();
    if (_tipoQuery.trim().isNotEmpty) params['tipoEmenda'] = _tipoQuery.trim();
    if (_anoController.text.trim().isNotEmpty) params['ano'] = _anoController.text.trim();

    try {

      final result = await _apiService.fetchEmendas(
        page: _page,
        params: params,
      );

      setState(() {
        _emendas = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _emendas = [];
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
    _buscarEmendas(page: 1);
  }

  @override
  void dispose() {
    _autorController.dispose();
    _anoController.dispose();
    super.dispose();
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
        iconTheme: IconThemeData(color: laranja),
        title: Text(
          'Emendas Parlamentares',
          style: TextStyle(
            color: texto,
            fontSize: settings.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Filtros
            TextField(
              controller: _autorController,
              style: TextStyle(color: texto, fontSize: settings.fontSize),
              decoration: _buildInputDecoration('Filtrar por autor', texto, fundoInput, laranja),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _tipoQuery.isEmpty ? 'Todos' : _tipoQuery,
              onChanged: (value) => setState(() => _tipoQuery = (value == null || value == 'Todos') ? '' : value),
              items: tiposDisponiveis.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(),
              decoration: _buildInputDecoration('Selecionar tipo', texto, fundoInput, laranja),
              dropdownColor: fundoInput,
              style: TextStyle(color: texto, fontSize: settings.fontSize),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _anoController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: texto, fontSize: settings.fontSize),
              decoration: _buildInputDecoration('Filtrar por ano', texto, fundoInput, laranja),
            ),
            const SizedBox(height: 16),

            // Botão de Pesquisa
            ElevatedButton.icon(
              onPressed: _loading ? null : () => _buscarEmendas(page: 1),
              icon: Icon(Icons.search, size: settings.fontSize, color: Colors.white),
              label: Text('Pesquisar', style: TextStyle(fontSize: settings.fontSize, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: laranja,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildResultView(texto, laranja, settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(Color texto, Color laranja, SettingsProvider settings) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: laranja));
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
    
    if (_emendas.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma emenda encontrada.',
          style: TextStyle(color: texto, fontSize: settings.fontSize),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _emendas.length,
            itemBuilder: (context, index) {
              return EmendaCard(
                emenda: _emendas[index],
                fontSize: settings.fontSize,
                isDark: settings.isDarkMode,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: _loading || _page <= 1 ? null : () => _buscarEmendas(page: _page - 1),
              child: const Text('Anterior'),
            ),
            Text('Página $_page', style: TextStyle(color: texto)),
            OutlinedButton(
              onPressed: _loading ? null : () => _buscarEmendas(page: _page + 1),
              child: const Text('Próxima'),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, Color textColor, Color fillColor, Color borderColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.withAlpha(400)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
    );
  }
}