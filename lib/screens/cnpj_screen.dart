import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faif/screens/config_manual_page.dart';

class CnpjPage extends StatefulWidget {
  @override
  CnpjPageState createState() => CnpjPageState();
}

class CnpjPageState extends State<CnpjPage> {
  final TextEditingController _controller = TextEditingController();
  String _resultado = "";
  bool _loading = false;

  Future<void> consultarCnpj() async {
    setState(() {
      _loading = true;
      _resultado = "";
    });
    final cnpj = _controller.text.trim();
    final url = Uri.parse('http://localhost:5000/faif/cnpj/$cnpj');
    final response = await http.get(url);
    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        final dados = json.decode(response.body);
        _resultado = const JsonEncoder.withIndent('  ').convert(dados);
      } else {
        _resultado = "Erro na consulta.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final fundo = isDarkMode ? Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = isDarkMode ? Colors.white : Colors.black;
    final laranja = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo, // mesmo tom da tela
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: laranja),
        title: Text(
          'Consultar CNPJ',
          style: TextStyle(
            color: texto, // destaque em laranja
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
                // Campo de busca customizado
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: laranja, width: 2),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(Icons.business, color: laranja),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: texto),
                          decoration: InputDecoration(
                            hintText: "XX. XXX. XXX/0001-XX",
                            hintStyle: TextStyle(color: fundoInput),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: laranja),
                        onPressed: _loading ? null : consultarCnpj,
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                if (_loading)
                  CircularProgressIndicator(color: laranja),
                if (_resultado.isNotEmpty && !_loading)
                  Builder(
                    builder: (context) {
                      final Map<String, dynamic> dados = json.decode(
                        _resultado,
                      );
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: fundoInput,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REPÚBLICA FEDERATIVA DA PESSOA JURÍDICA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'COMPROVANTE DE INSCRIÇÃO E DE SITUAÇÃO CADASTRAL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                color: texto,
                              ),
                            ),
                            Divider(color: Colors.white24, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'NOME EMPRESARIAL',
                                  dados['nome'] ?? '',
                                  color: texto,
                                ),
                                _campo(
                                  'DATA DE ABERTURA',
                                  dados['abertura'] ?? '',
                                  color: texto,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'NOME FANTASIA',
                                  dados['fantasia'] ?? '',
                                  color: texto,
                                ),
                                _campo(
                                  'PORTE',
                                  dados['porte'] ?? '',
                                  color: texto,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'CNPJ',
                                  dados['cnpj'] ?? '',
                                  color: texto,
                                ),
                                _campo(
                                  'NATUREZA JURÍDICA',
                                  dados['natureza_juridica'] ?? '',
                                  color: texto,
                                ),
                              ],
                            ),
                            Divider(color: Colors.white24, height: 24),
                            Text(
                              'ATIVIDADE PRINCIPAL:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: texto,
                              ),
                            ),
                            ...((dados['atividade_principal'] ?? []) as List)
                                .map<Widget>(
                                  (a) => Text(
                                    '${a['code'] ?? ''} - ${a['text'] ?? ''}',
                                    style: TextStyle(color: texto),
                                  ),
                                ),
                            SizedBox(height: 8),
                            if ((dados['atividades_secundarias'] ?? [])
                                .isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ATIVIDADES SECUNDÁRIAS:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: texto,
                                    ),
                                  ),
                                  ...((dados['atividades_secundarias'] ?? [])
                                          as List)
                                      .map<Widget>(
                                        (a) => Text(
                                          '${a['code'] ?? ''} - ${a['text'] ?? ''}',
                                          style: TextStyle(
                                            color: texto,
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            Divider(color: Colors.white24, height: 24),
                            Text(
                              'ENDEREÇO:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: texto,
                              ),
                            ),
                            Text(
                              '${dados['logradouro'] ?? ''}, ${dados['numero'] ?? ''} ${dados['complemento'] ?? ''}\n${dados['bairro'] ?? ''} - ${dados['municipio'] ?? ''}/${dados['uf'] ?? ''}\nCEP: ${dados['cep'] ?? ''}',
                              style: TextStyle(color: texto),
                            ),
                            Divider(color: Colors.white24, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'SITUAÇÃO CADASTRAL',
                                  dados['situacao'] ?? '',
                                  color: texto,
                                ),
                                _campo(
                                  'DATA DA SITUAÇÃO CADASTRAL',
                                  dados['data_situacao'] ?? '',
                                  color: texto,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'CAPITAL SOCIAL',
                                  dados['capital_social'] ?? '',
                                  color: texto,
                                ),
                                _campo(
                                  'MOTIVO DE SITUAÇÃO CADASTRAL',
                                  dados['motivo_situacao'] ?? '',
                                  color: texto,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'SITUAÇÃO ESPECIAL',
                                  dados['situacao_especial'] ?? '',
                                  color: texto,
                                ),
                                _campo(
                                  'DATA DA SITUAÇÃO ESPECIAL',
                                  dados['data_situacao_especial'] ?? '',
                                  color: texto,
                                ),
                              ],
                            ),
                            Divider(color: Colors.white24, height: 24),
                            if ((dados['qsa'] ?? []).isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'QUADRO SOCIETÁRIO:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: texto,
                                    ),
                                  ),
                                  ...((dados['qsa'] ?? []) as List).map<Widget>(
                                    (s) => Text(
                                      '${s['qual'] ?? ''}: ${s['nome'] ?? ''}',
                                      style: TextStyle(color: texto),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Função auxiliar para exibir campos com título e valor
Widget _campo(String titulo, String valor, {Color? color}) {
  if (valor.isEmpty) return SizedBox.shrink();

  final corTexto = color ?? (isDarkMode ? Color(0xFF1A1A1A) : Colors.white);

  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: RichText(
      text: TextSpan(
        style: TextStyle(color: corTexto, fontSize: fontSize),
        children: [
          TextSpan(
            text: '$titulo: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: corTexto),
          ),
          TextSpan(
            text: valor,
            style: TextStyle(color: corTexto),
          ),
        ],
      ),
    ),
  );
}}