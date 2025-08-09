class CguConjunto {
  final String id;
  final String titulo;
  final String descricao;

  CguConjunto({
    required this.id,
    required this.titulo,
    required this.descricao,
  });

  factory CguConjunto.fromJson(Map<String, dynamic> json) {
    return CguConjunto(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
    );
  }
}
