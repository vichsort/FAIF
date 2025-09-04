class ClassificacaoTematica {
  final String nome;
  final String dominio;
  
  ClassificacaoTematica({required this.nome, required this.dominio});

  factory ClassificacaoTematica.fromJson(Map<String, dynamic> json) {
    return ClassificacaoTematica(
      nome: json['nome'] ?? '',
      dominio: json['dominio'] ?? '',
    );
  }
}

class PesquisaIBGE {
  final String categoria;
  final List<ClassificacaoTematica> classificacoesTematicas;
  final String codigo;
  final String nome;
  final String periodicidadeDivulgacao;
  final String situacao;

  PesquisaIBGE({
    required this.categoria,
    required this.classificacoesTematicas,
    required this.codigo,
    required this.nome,
    required this.periodicidadeDivulgacao,
    required this.situacao,
  });

  factory PesquisaIBGE.fromJson(Map<String, dynamic> json) {
    var temas = json['classificacoes_tematicas'] as List?;
    List<ClassificacaoTematica> temasList = temas
        ?.map((e) => ClassificacaoTematica.fromJson(e))
        .toList() ?? [];

    return PesquisaIBGE(
      categoria: json['categoria'] ?? '',
      classificacoesTematicas: temasList,
      codigo: json['codigo'] ?? '',
      nome: json['nome'] ?? 'Nome indisponível',
      periodicidadeDivulgacao: json['periodicidade_divulgacao'] ?? '',
      situacao: json['situacao'] ?? 'Inativa',
    );
  }
}