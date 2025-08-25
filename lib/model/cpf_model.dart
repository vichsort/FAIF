class CpfModel {
  final String nome;
  final String nomeSocial;
  final String dataNascimento;
  final String sexo;
  final String telefone;
  final Endereco endereco;
  final Ocupacao ocupacao;

  CpfModel({
    required this.nome,
    required this.nomeSocial,
    required this.dataNascimento,
    required this.sexo,
    required this.telefone,
    required this.endereco,
    required this.ocupacao,
  });

  factory CpfModel.fromJson(Map<String, dynamic> json) {
    return CpfModel(
      nome: json['nome'] ?? '',
      nomeSocial: json['nomeSocial'] ?? '',
      dataNascimento: json['dataNascimento'] ?? '',
      sexo: json['sexo'] ?? '',
      telefone: json['telefone'] ?? '',
      endereco: Endereco.fromJson(json['endereco'] ?? {}),
      ocupacao: Ocupacao.fromJson(json['ocupacao'] ?? {}),
    );
  }
}

class Endereco {
  final String numero;
  final String complemento;
  final String bairro;
  final String cep;
  final String municipio;
  final String uf;

  Endereco({
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cep,
    required this.municipio,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      numero: json['numero'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      cep: json['cep'] ?? '',
      municipio: json['municipio'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}

class Ocupacao {
  final String natureza;
  final String nomeNatureza;
  final String ocupacaoPrincipal;
  final String nomeOcupacaoPrincipal;
  final String exercicio;

  Ocupacao({
    required this.natureza,
    required this.nomeNatureza,
    required this.ocupacaoPrincipal,
    required this.nomeOcupacaoPrincipal,
    required this.exercicio,
  });

  factory Ocupacao.fromJson(Map<String, dynamic> json) {
    return Ocupacao(
      natureza: json['natureza'] ?? '',
      nomeNatureza: json['nomeNatureza'] ?? '',
      ocupacaoPrincipal: json['ocupacaoPrincipal'] ?? '',
      nomeOcupacaoPrincipal: json['nomeOcupacaoPrincipal'] ?? '',
      exercicio: json['exercicio'] ?? '',
    );
  }
}
