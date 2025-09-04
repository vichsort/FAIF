class Atividade {
  final String code;
  final String text;

  Atividade({required this.code, required this.text});

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      code: json['code']?.toString() ?? json['codigo']?.toString() ?? '',
      text: json['text'] ?? json['descricao'] ?? '',
    );
  }
}

class Socio {
  final String nome;
  final String qual;

  Socio({required this.nome, required this.qual});

  factory Socio.fromJson(Map<String, dynamic> json) {
    return Socio(
      nome: json['nome_socio'] ?? json['nome'] ?? '',
      qual: json['qualificacao_socio'] ?? json['qual'] ?? '',
    );
  }
}

class CnpjModel {
  final String cnpj;
  final String razaoSocial;
  final String nomeFantasia;
  final String situacao;
  final String dataSituacaoCadastral;
  final String motivoSituacaoCadastral;
  final String identificadorMatrizFilial;
  final String dataInicioAtividade;
  final String cnaeFiscalDescricao;
  final String logradouro;
  final String numero;
  final String complemento;
  final String bairro;
  final String cep;
  final String municipio;
  final String uf;
  final String porte;
  final String naturezaJuridica;
  final int capitalSocial;
  final List<Socio> qsa;
  final List<Atividade> cnaesSecundarios;

  final Atividade? atividadePrincipal;

  CnpjModel({
    required this.cnpj,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.situacao,
    required this.dataSituacaoCadastral,
    required this.motivoSituacaoCadastral,
    required this.identificadorMatrizFilial,
    required this.dataInicioAtividade,
    required this.cnaeFiscalDescricao,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cep,
    required this.municipio,
    required this.uf,
    required this.porte,
    required this.naturezaJuridica,
    required this.capitalSocial,
    required this.qsa,
    required this.cnaesSecundarios,
    this.atividadePrincipal,
  });

  factory CnpjModel.fromJson(Map<String, dynamic> json) {
    return CnpjModel(
      cnpj: json['cnpj'] ?? '',
      razaoSocial: json['razao_social'] ?? json['nome'] ?? '',
      nomeFantasia: json['nome_fantasia'] ?? json['fantasia'] ?? '',
      situacao: json['descricao_situacao_cadastral'] ?? json['situacao'] ?? 'INATIVA',
      dataSituacaoCadastral: json['data_situacao_cadastral'] ?? '',
      motivoSituacaoCadastral: json['descricao_motivo_situacao_cadastral'] ?? '',
      identificadorMatrizFilial: json['descricao_identificador_matriz_filial'] ?? '',
      dataInicioAtividade: json['data_inicio_atividade'] ?? json['abertura'] ?? '',
      cnaeFiscalDescricao: json['cnae_fiscal_descricao'] ?? '',
      logradouro: json['logradouro'] ?? '',
      numero: json['numero'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      cep: json['cep'] ?? '',
      municipio: json['municipio'] ?? '',
      uf: json['uf'] ?? '',
      porte: json['porte'] ?? '',
      naturezaJuridica: json['natureza_juridica'] ?? '',
      capitalSocial: (json['capital_social'] is String ? 0 : json['capital_social']) ?? 0,
      qsa: (json['qsa'] as List<dynamic>?)?.map((e) => Socio.fromJson(e)).toList() ?? [],
      cnaesSecundarios: (json['cnaes_secundarios'] as List<dynamic>?)?.map((e) => Atividade.fromJson(e)).toList() ?? [],
      atividadePrincipal: json['cnae_fiscal'] != null 
        ? Atividade(code: json['cnae_fiscal'].toString(), text: json['cnae_fiscal_descricao'] ?? '') 
        : null,
    );
  }
}