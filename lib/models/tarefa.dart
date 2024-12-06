class Tarefa {
  String id;
  String titulo;
  String descricao;
  bool estaConcluida;
  DateTime dataCriacao;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.estaConcluida = false,
    required this.dataCriacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'estaConcluida': estaConcluida,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  factory Tarefa.fromMap(String id, Map<String, dynamic> map) {
    return Tarefa(
      id: id,
      titulo: map['titulo'],
      descricao: map['descricao'],
      estaConcluida: map['estaConcluida'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
    );
  }
}