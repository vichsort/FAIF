import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/deputado_model.dart';
import '../model/deputado_detalhes_model.dart';

import '../model/emenda_model.dart';
import '../model/ibge_model.dart';
import '../model/cnpj_model.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:5000';

  Future<List<Deputado>> fetchDeputados(String nome) async {
    final url = Uri.parse('$_baseUrl/faif/deputados?nome=$nome');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);

        if (decodedJson['ok'] == true) {
          final List<dynamic> dataList = decodedJson['data'];
          return dataList.map((json) => Deputado.fromJson(json)).toList();
        } else {
          throw Exception('Erro da API: ${decodedJson['error']['message']}');
        }
      } else {
        throw Exception(
          'Falha ao carregar deputados. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
      throw Exception(
        'Não foi possível conectar ao servidor. Verifique sua conexão.',
      );
    }
  }

  Future<DeputadoDetalhes> fetchDeputadoDetails(int id) async {
    final url = Uri.parse('$_baseUrl/faif/deputados/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        if (decodedJson['ok'] == true) {
          return DeputadoDetalhes.fromJson(decodedJson['data']);
        } else {
          throw Exception('Erro da API: ${decodedJson['error']['message']}');
        }
      } else {
        throw Exception(
          'Falha ao carregar detalhes do deputado. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
      throw Exception('Não foi possível conectar ao servidor.');
    }
  }

  Future<List<EmendaModel>> fetchEmendas({
    required int page,
    Map<String, String>? params,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/faif/transparencia/emendas/$page',
    ).replace(queryParameters: params);

    try {
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);

        if (decodedJson['ok'] == true) {
          final List<dynamic> dataList = decodedJson['data'];
          return dataList.map((json) => EmendaModel.fromJson(json)).toList();
        } else {
          throw Exception('Erro da API: ${decodedJson['error']['message']}');
        }
      } else {
        throw Exception(
          'Falha ao buscar emendas. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
      throw Exception('Não foi possível conectar ao servidor.');
    }
  }

  Future<CnpjModel> fetchCnpj(String cnpj) async {
    final digits = cnpj.replaceAll(RegExp(r'[.\-/\s]'), '');
    final url = Uri.parse('$_baseUrl/faif/cnpj/$digits');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        if (decodedJson['ok'] == true) {
          return CnpjModel.fromJson(decodedJson['data']);
        } else {
          throw Exception('Erro da API: ${decodedJson['error']['message']}');
        }
      } else {
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        final errorMessage =
            errorJson['error']?['message'] ?? 'Erro desconhecido.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print(e);
      throw Exception(
        'Não foi possível conectar ao servidor. Verifique sua conexão.',
      );
    }
  }

  Future<List<PesquisaIBGE>> fetchIbge(String? termo) async {
    final params = <String, String>{};
    if (termo != null && termo.isNotEmpty) {
      params['q'] = termo;
    }

    final url = Uri.parse(
      '$_baseUrl/faif/ibge',
    ).replace(queryParameters: params.isEmpty ? null : params);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        if (decodedJson['ok'] == true) {
          final List<dynamic> dataList = decodedJson['data'];
          return dataList.map((json) => PesquisaIBGE.fromJson(json)).toList();
        } else {
          throw Exception('Erro da API: ${decodedJson['error']['message']}');
        }
      } else {
        throw Exception(
          'Falha ao carregar dados do IBGE. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
      throw Exception('Não foi possível conectar ao servidor.');
    }
  }
}
