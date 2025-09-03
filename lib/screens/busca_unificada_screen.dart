import 'dart:convert';
import 'package:faif/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:faif/model/resultado_model.dart';
import 'package:faif/components/resultado_card.dart';
import 'package:provider/provider.dart';

class BuscaUnificadaPage extends StatefulWidget {
  const BuscaUnificadaPage({super.key});
  @override
  State<BuscaUnificadaPage> createState() => _BuscaUnificadaPageState();
}

class _BuscaUnificadaPageState extends State<BuscaUnificadaPage> {
  String _dominioSelecionado = 'Deputados';
  final TextEditingController _controller = TextEditingController();
  List<ResultadoBusca> _resultados = [];
  bool _carregando = false;

  final List<String> dominios = ['Deputados', 'Emendas', 'IBGE', 'CNPJ'];

  Future<List<ResultadoBusca>> buscarDeputados(String termo) async {
    final url = Uri.parse(
      'https://dadosabertos.camara.leg.br/api/v2/deputados?nome=$termo',
    );
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['dados'] as List;
      return data
          .map(
            (d) => ResultadoBusca(
              titulo: d['nome'] ?? '—',
              descricao:
                  'Partido: ${d['siglaPartido'] ?? ''} | UF: ${d['siglaUf'] ?? ''}',
              link: d['uri'] ?? '',
            ),
          )
          .toList();
    }
    return [];
  }

  Future<List<ResultadoBusca>> buscarEmendas(String termo) async {
    final url = Uri.parse(
      'https://api.portaldatransparencia.gov.br/api-de-dados/emendas?pagina=1&nomeAutor=${termo.toUpperCase()}',
    );
    final resp = await http.get(
      url,
      headers: {
        'chave-api-dados': 'SUA_CHAVE_AQUI',
        'Accept': 'application/json',
        'User-Agent': 'FAIFApi/1.0',
      },
    );
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as List;
      return data
          .map(
            (e) => ResultadoBusca(
              titulo: e['nomeAutor'] ?? '—',
              descricao:
                  'Emenda: ${e['numeroEmenda'] ?? ''} – Ano: ${e['ano'] ?? ''}',
              link: '', // sem link oficial
            ),
          )
          .toList();
    }
    return [];
  }

  Future<List<ResultadoBusca>> buscarIbge(String termo) async {
    final url = Uri.parse(
      'https://servicodados.ibge.gov.br/api/v2/metadados/Pesquisa?q=$termo',
    );
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as List;
      return data
          .map(
            (e) => ResultadoBusca(
              titulo: e['nome'] ?? '—',
              descricao: 'Categoria: ${e['categoria'] ?? ''}',
              link: 'https://www.ibge.gov.br/pesquisa/${e['codigo'] ?? ''}',
            ),
          )
          .toList();
    }
    return [];
  }

  Future<List<ResultadoBusca>> buscarCnpj(String termo) async {
    final digits = termo.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('https://brasilapi.com.br/api/cnpj/v1/$digits');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final e = json.decode(resp.body);
      return [
        ResultadoBusca(
          titulo: e['nome'] ?? '—',
          descricao: e['atividade_principal']?[0]?['text'] ?? '',
          link: '', // sem link oficial
        ),
      ];
    }
    return [];
  }

  Future<void> _realizarBusca() async {
    final termo = _controller.text.trim();
    if (termo.isEmpty) return;

    setState(() {
      _carregando = true;
      _resultados = [];
    });

    List<ResultadoBusca> resultados = [];
    if (_dominioSelecionado == 'Deputados') {
      resultados = await buscarDeputados(termo);
    } else if (_dominioSelecionado == 'Emendas') {
      resultados = await buscarEmendas(termo);
    } else if (_dominioSelecionado == 'IBGE') {
      resultados = await buscarIbge(termo);
    } else if (_dominioSelecionado == 'CNPJ') {
      resultados = await buscarCnpj(termo);
    }

    setState(() {
      _resultados = resultados;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final fundo = settings.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final laranja = const Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        iconTheme: IconThemeData(color: laranja),
        title: const Text("Busca Unificada"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Digite o termo de busca",
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                          color: Color(0xFFFF6B35),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                          color: Color(0xFFFF6B35),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _dominioSelecionado,
                  onChanged: (valor) =>
                      setState(() => _dominioSelecionado = valor!),
                  items: dominios
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _realizarBusca,
                  color: laranja,
                ),
              ],
            ),
          ),
          if (_carregando) const LinearProgressIndicator(),
          Expanded(
            child: _resultados.isEmpty
                ? const Center(child: Text("Nenhum resultado"))
                : ListView.builder(
                    itemCount: _resultados.length,
                    itemBuilder: (context, idx) =>
                        ResultadoCard(resultado: _resultados[idx]),
                  ),
          ),
        ],
      ),
    );
  }
}
