class Gabinete {
  final String? nome;
  final String? predio;
  final String? sala;
  final String? andar;
  final String? telefone;
  final String? email;

  Gabinete({this.nome, this.predio, this.sala, this.andar, this.telefone, this.email});

  factory Gabinete.fromJson(Map<String, dynamic> json) {
    return Gabinete(
      nome: json['nome'],
      predio: json['predio'],
      sala: json['sala'],
      andar: json['andar'],
      telefone: json['telefone'],
      email: json['email'],
    );
  }
}

class DeputadoDetalhes {
  final int id;
  final String? nomeCivil;
  final String? nomeEleitoral;
  final String? siglaPartido;
  final String? situacao;
  final String? condicaoEleitoral;
  final String? cpf;
  final String? sexo;
  final String? dataNascimento;
  final String? escolaridade;
  final String? urlFoto;
  final Gabinete? gabinete;
  final List<String> redesSociais;

  DeputadoDetalhes({
    required this.id,
    this.nomeCivil,
    this.nomeEleitoral,
    this.siglaPartido,
    this.situacao,
    this.condicaoEleitoral,
    this.cpf,
    this.sexo,
    this.dataNascimento,
    this.escolaridade,
    this.urlFoto,
    this.gabinete,
    required this.redesSociais,
  });

  factory DeputadoDetalhes.fromJson(Map<String, dynamic> json) {
    var redes = json['redesSociais'] as List?;
    List<String> redesSociaisList = redes?.map((e) => e.toString()).toList() ?? [];
    
    return DeputadoDetalhes(
      id: json['id'],
      nomeCivil: json['nomeCivil'],
      nomeEleitoral: json['nomeEleitoral'],
      siglaPartido: json['partido']?['sigla'],
      situacao: json['situacao'],
      condicaoEleitoral: json['condicaoEleitoral'],
      cpf: json['cpf'],
      sexo: json['sexo'],
      dataNascimento: json['dataNascimento'],
      escolaridade: json['escolaridade'],
      urlFoto: json['urlFoto'],
      gabinete: json['gabinete'] != null ? Gabinete.fromJson(json['gabinete']) : null,
      redesSociais: redesSociaisList,
    );
  }
}