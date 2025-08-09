class CpfConjunto {
  final String id;
  final String titulo;
  final String descricao;

  CpfConjunto({
    required this.id,
    required this.titulo,
    required this.descricao,
  });

  factory CpfConjunto.fromJson(Map<String, dynamic> json) {
    return CpfConjunto(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
    );
  }
}
