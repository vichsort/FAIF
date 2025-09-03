class EmendaModel {
  final String codigoEmenda;
  final int ano;
  final String tipoEmenda;
  final String autor;
  final String nomeAutor;
  final String numeroEmenda;
  final String localidadeDoGasto;
  final String funcao;
  final String subfuncao;
  final String valorPago;
  final String valorEmpenhado;

  EmendaModel({
    required this.codigoEmenda,
    required this.ano,
    required this.tipoEmenda,
    required this.autor,
    required this.nomeAutor,
    required this.numeroEmenda,
    required this.localidadeDoGasto,
    required this.funcao,
    required this.subfuncao,
    required this.valorPago,
    required this.valorEmpenhado,
  });

  factory EmendaModel.fromJson(Map<String, dynamic> json) {
    return EmendaModel(
      codigoEmenda: json['codigoEmenda'] ?? 'S/I',
      ano: json['ano'] ?? 0,
      tipoEmenda: json['tipoEmenda'] ?? '',
      autor: json['autor'] ?? '',
      nomeAutor: json['nomeAutor'] ?? '',
      numeroEmenda: json['numeroEmenda'] ?? 'S/I',
      localidadeDoGasto: json['localidadeDoGasto'] ?? '',
      funcao: json['funcao'] ?? '',
      subfuncao: json['subfuncao'] ?? '',
      valorPago: json['valorPago'] ?? '0,00',
      valorEmpenhado: json['valorEmpenhado'] ?? '0,00',
    );
  }
}