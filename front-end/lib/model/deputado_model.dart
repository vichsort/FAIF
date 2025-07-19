class Deputado {
  final String nome;
  final String email;
  final int id;
  final String siglaPartido;
  final String siglaUf;
  final String urlFoto;

  Deputado({
    required this.nome,
    required this.email,
    required this.id,
    required this.siglaPartido,
    required this.siglaUf,
    required this.urlFoto,
  });

  factory Deputado.fromJson(Map<String, dynamic> json) {
    return Deputado(
      nome: json['nome'],
      email: json['email'],
      id: json['id'],
      siglaPartido: json['siglaPartido'],
      siglaUf: json['siglaUf'],
      urlFoto: json['urlFoto'],
    );
  }
}
