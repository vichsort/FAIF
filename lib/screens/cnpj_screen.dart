import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faif/screens/config_manual_page.dart';

class ConsultaCnpjPage extends StatefulWidget {
  @override
  _ConsultaCnpjPageState createState() => _ConsultaCnpjPageState();
}

class _ConsultaCnpjPageState extends State<ConsultaCnpjPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _dados;
  String? _erro;

  Future<void> consultarCnpj() async {
    setState(() {
      _loading = true;
      _dados = null;
      _erro = null;
    });
    final cnpj = _controller.text.trim().replaceAll(RegExp(r'[.\-/\s]'), '');
    if (cnpj.isEmpty) {
      setState(() {
        _loading = false;
        _erro = 'Informe um CNPJ.';
      });
      return;
    }

    final url = Uri.parse('http://localhost:5000/cnpj/$cnpj');
    try {
      final response = await http.get(url);
      setState(() {
        _loading = false;
        if (response.statusCode == 200) {
          final Map<String, dynamic> dados = json.decode(response.body);
          _dados = dados;
        } else {
          try {
            final Map<String, dynamic> err = json.decode(response.body);
            _erro = err['error']?['message'] ?? 'Erro na consulta.';
          } catch (_) {
            _erro = 'Erro na consulta.';
          }
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _erro = 'Falha de conexão com a API.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fundo = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  style: TextStyle(color: texto, fontSize: fontSize),
                  onSubmitted: (_) => consultarCnpj(),
                  decoration: InputDecoration(
                    labelText: 'CNPJ',
                    labelStyle: TextStyle(
                      color: texto,
                      fontSize: fontSize - 2,
                    ),
                    hintText: 'XX.XXX.XXX/0001-XX',
                    hintStyle: TextStyle(
                      color: texto,
                      fontSize: fontSize - 2,
                    ),
                    filled: true,
                    fillColor: fundoInput,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      borderSide: BorderSide(color: laranja, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      borderSide: BorderSide(color: laranja, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: laranja),
                      onPressed: _loading ? null : consultarCnpj,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 24),

                if (_loading) CircularProgressIndicator(color: laranja),

                if (!_loading && _erro != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF2B1B16)
                          : const Color(0xFFFFE9E1),
                      border: Border.all(color: laranja, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _erro!,
                      style: TextStyle(color: texto, fontSize: fontSize),
                    ),
                  ),

                if (!_loading && _dados != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF100C0A)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: laranja, width: 2),
                    ),
                    child: _CnpjDetalhes(
                      dados: _dados!,
                      texto: texto,
                      laranja: laranja,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CnpjDetalhes extends StatelessWidget {
  final Map<String, dynamic> dados;
  final Color texto;
  final Color laranja;

  const _CnpjDetalhes({
    required this.dados,
    required this.texto,
    required this.laranja,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REPÚBLICA FEDERATIVA DA PESSOA JURÍDICA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: texto,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'COMPROVANTE DE INSCRIÇÃO E DE SITUAÇÃO CADASTRAL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: texto,
          ),
        ),
        Divider(color: texto.withOpacity(0.2), height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _linha('NOME EMPRESARIAL', dados['nome'] ?? '', texto),
            _linha('DATA DE ABERTURA', dados['abertura'] ?? '', texto),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _linha('NOME FANTASIA', dados['fantasia'] ?? '', texto),
            _linha('PORTE', dados['porte'] ?? '', texto),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _linha('CNPJ', dados['cnpj'] ?? '', texto),
            _linha(
              'NATUREZA JURÍDICA',
              dados['natureza_juridica'] ?? '',
              texto,
            ),
          ],
        ),
        Divider(color: texto.withOpacity(0.2), height: 24),
        Text(
          'ATIVIDADE PRINCIPAL:',
          style: TextStyle(fontWeight: FontWeight.bold, color: texto),
        ),
        ...((dados['atividade_principal'] ?? []) as List)
            .map<Widget>(
              (a) => Text(
                '${a['code'] ?? ''} - ${a['text'] ?? ''}',
                style: TextStyle(color: texto.withOpacity(0.7)),
              ),
            )
            .toList(),
        const SizedBox(height: 8),
        if ((dados['atividades_secundarias'] ?? []).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ATIVIDADES SECUNDÁRIAS:',
                style: TextStyle(fontWeight: FontWeight.bold, color: texto),
              ),
              ...((dados['atividades_secundarias'] ?? []) as List)
                  .map<Widget>(
                    (a) => Text(
                      '${a['code'] ?? ''} - ${a['text'] ?? ''}',
                      style: TextStyle(color: texto.withOpacity(0.7)),
                    ),
                  )
                  .toList(),
            ],
          ),
        Divider(color: texto.withOpacity(0.2), height: 24),
        Text(
          'ENDEREÇO:',
          style: TextStyle(fontWeight: FontWeight.bold, color: texto),
        ),
        Text(
          '${dados['logradouro'] ?? ''}, ${dados['numero'] ?? ''} ${dados['complemento'] ?? ''}\n${dados['bairro'] ?? ''} - ${dados['municipio'] ?? ''}/${dados['uf'] ?? ''}\nCEP: ${dados['cep'] ?? ''}',
          style: TextStyle(color: texto.withOpacity(0.7)),
        ),
        Divider(color: texto.withOpacity(0.2), height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _linha('SITUAÇÃO CADASTRAL', dados['situacao'] ?? '', texto),
            _linha(
              'DATA DA SITUAÇÃO CADASTRAL',
              dados['data_situacao'] ?? '',
              texto,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _linha('CAPITAL SOCIAL', dados['capital_social'] ?? '', texto),
            _linha(
              'MOTIVO DE SITUAÇÃO CADASTRAL',
              dados['motivo_situacao'] ?? '',
              texto,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _linha(
              'SITUAÇÃO ESPECIAL',
              dados['situacao_especial'] ?? '',
              texto,
            ),
            _linha(
              'DATA DA SITUAÇÃO ESPECIAL',
              dados['data_situacao_especial'] ?? '',
              texto,
            ),
          ],
        ),
        Divider(color: texto.withOpacity(0.2), height: 24),
        if ((dados['qsa'] ?? []).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QUADRO SOCIETÁRIO:',
                style: TextStyle(fontWeight: FontWeight.bold, color: texto),
              ),
              ...((dados['qsa'] ?? []) as List)
                  .map<Widget>(
                    (s) => Text(
                      '${s['qual'] ?? ''}: ${s['nome'] ?? ''}',
                      style: TextStyle(color: texto.withOpacity(0.7)),
                    ),
                  )
                  .toList(),
            ],
          ),
      ],
    );
  }

  Widget _linha(String titulo, Object? valor, Color color) {
    final text = (valor ?? '').toString();
    if (text.isEmpty) return const SizedBox.shrink();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: color, fontSize: 13),
            children: [
              TextSpan(
                text: '$titulo: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              TextSpan(
                text: text,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
