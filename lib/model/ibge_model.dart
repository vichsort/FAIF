class PesquisaIBGE {
  final String codigo;
  final String nome;
  final String categoria;
  final List<ClassificacaoTematica> classificacoesTematicas;

  PesquisaIBGE({
    required this.codigo,
    required this.nome,
    required this.categoria,
    required this.classificacoesTematicas,
  });

  factory PesquisaIBGE.fromJson(Map<String, dynamic> json) {
    return PesquisaIBGE(
      codigo: json['codigo'],
      nome: json['nome'],
      categoria: json['categoria'],
      classificacoesTematicas: json['classificacoes_tematicas'] != null
          ? (json['classificacoes_tematicas'] as List)
              .map((e) => ClassificacaoTematica.fromJson(e))
              .toList()
          : [],
    );
  }
}

class ClassificacaoTematica {
  final String nome;
  final String descricao;
  final String dominio;

  ClassificacaoTematica({
    required this.nome,
    required this.descricao,
    required this.dominio,
  });

  factory ClassificacaoTematica.fromJson(Map<String, dynamic> json) {
    return ClassificacaoTematica(
      nome: json['nome'],
      descricao: json['descricao'] ?? '',
      dominio: json['dominio'] ?? '',
    );
  }
}
