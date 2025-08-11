import 'package:flutter/material.dart';
import 'package:faif/model/emenda_model.dart';
import 'package:faif/components/emenda_card.dart';
import 'package:faif/screens/config_manual_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmendasPage extends StatefulWidget {
  final List<EmendaModel> emendas;

  const EmendasPage({required this.emendas, super.key});

  @override
  State<EmendasPage> createState() => _EmendasPageState();
}

class _EmendasPageState extends State<EmendasPage> {
  String autorQuery = '';
  String tipoQuery = '';
  String anoQuery = '';
  bool _loading = false;
  int _page = 1;
  List<EmendaModel> _emendas = [];

  final List<String> tiposDisponiveis = [
    'Todos',
    'Individual',
    'De bancada',
    'De comissão',
    'De relator',
    'Extraordinária',
  ];

  Future<void> _buscarEmendas({int? page}) async {
    setState(() {
      _loading = true;
      if (page != null) _page = page;
    });

    final params = <String, String>{};
    if (autorQuery.trim().isNotEmpty) params['nomeAutor'] = autorQuery.trim();
    if (tipoQuery.trim().isNotEmpty) params['tipoEmenda'] = tipoQuery.trim();
    if (anoQuery.trim().isNotEmpty) params['ano'] = anoQuery.trim();

    final uri = Uri.parse(
      'http://localhost:5000/faif/portal-transparencia/emendas/$_page',
    ).replace(queryParameters: params.isEmpty ? null : params);

    try {
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final List<dynamic> dados = json.decode(resp.body);
        final lista = dados
            .map((e) => EmendaModel.fromJson(e as Map<String, dynamic>))
            .toList();
        setState(() {
          _emendas = lista;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _emendas = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao buscar emendas.')),
        );
      }
    } catch (_) {
      setState(() {
        _loading = false;
        _emendas = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha de conexão com a API.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _emendas = List.from(widget.emendas);
    // Busca inicial (página 1, sem filtros) para popular a tela
    _buscarEmendas(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final fundo = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);

    // Resultado exibido é exatamente o retornado pela API após aplicar filtros
    final emendasFiltradas = _emendas;

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
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Campo: Autor
            TextField(
              onChanged: (value) => autorQuery = value,
              style: TextStyle(color: texto, fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Filtrar por autor',
                labelStyle: TextStyle(color: texto),
                filled: true,
                fillColor: fundoInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: laranja),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Campo: Tipo (Dropdown)
            DropdownButtonFormField<String>(
              value: tipoQuery.isEmpty ? 'Todos' : tipoQuery,
              onChanged: (value) {
                setState(() {
                  if (value == null || value == 'Todos') {
                    tipoQuery = '';
                  } else {
                    tipoQuery = value;
                  }
                });
              },
              items: tiposDisponiveis.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(
                    tipo,
                    style: TextStyle(color: texto, fontSize: fontSize),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Selecionar tipo',
                labelStyle: TextStyle(color: texto),
                filled: true,
                fillColor: fundoInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: laranja),
                ),
              ),
              dropdownColor: fundoInput,
              style: TextStyle(color: texto, fontSize: fontSize),
            ),
            const SizedBox(height: 10),

            // Campo: Ano
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => anoQuery = value,
              style: TextStyle(color: texto, fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Filtrar por ano',
                labelStyle: TextStyle(color: texto),
                filled: true,
                fillColor: fundoInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: laranja),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botão de pesquisa
            ElevatedButton.icon(
              onPressed: _loading
                  ? null
                  : () {
                      // Dispara busca no backend com os filtros atuais
                      _buscarEmendas(page: 1);
                    },
              icon: Icon(Icons.search, size: fontSize, color: Colors.white),
              label: Text(
                'Pesquisar',
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: laranja,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de cards
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: laranja))
                  : emendasFiltradas.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma emenda encontrada.',
                        style: TextStyle(color: texto, fontSize: fontSize),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: emendasFiltradas.length,
                            itemBuilder: (context, index) {
                              return EmendaCard(
                                emenda: emendasFiltradas[index],
                                fontSize: fontSize,
                                isDark: isDarkMode,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: _loading || _page <= 1
                                  ? null
                                  : () => _buscarEmendas(page: _page - 1),
                              child: const Text('Anterior'),
                            ),
                            Text(
                              'Página $_page',
                              style: TextStyle(color: texto),
                            ),
                            OutlinedButton(
                              onPressed: _loading
                                  ? null
                                  : () => _buscarEmendas(page: _page + 1),
                              child: const Text('Próxima'),
                            ),
                          ],
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
