class EmendaModel {
  final String codigoEmenda;
  final String numeroEmenda;
  final String nomeAutor;
  final String tipoEmenda;
  final String codigoFuncao;
  final String codigoSubfuncao;
  final int ano;
  final String data;
  final String titulo;
  final String titularAcao;
  final String referencia;

  EmendaModel({
    required this.codigoEmenda,
    required this.numeroEmenda,
    required this.nomeAutor,
    required this.tipoEmenda,
    required this.codigoFuncao,
    required this.codigoSubfuncao,
    required this.ano,
    required this.data,
    required this.titulo,
    required this.titularAcao,
    required this.referencia,
  });

  factory EmendaModel.fromJson(Map<String, dynamic> json) {
    return EmendaModel(
      codigoEmenda: json['codigoEmenda'] ?? '',
      numeroEmenda: json['numeroEmenda'] ?? '',
      nomeAutor: json['nomeAutor'] ?? '',
      tipoEmenda: json['tipoEmenda'] ?? '',
      codigoFuncao: json['codigoFuncao'] ?? '',
      codigoSubfuncao: json['codigoSubfuncao'] ?? '',
      ano: json['ano'] ?? 0,
      data: json['data'] ?? '',
      titulo: json['titulo'] ?? '',
      titularAcao: json['titularAcao'] ?? '',
      referencia: json['referencia'] ?? '',
    );
  }
}
