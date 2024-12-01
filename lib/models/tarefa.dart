class Tarefa {
  final int? id;
  final String titulo;
  bool estaConcluida;

  Tarefa({this.id, required this.titulo, this.estaConcluida = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'estaConcluida': estaConcluida ? 1 : 0,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      estaConcluida: map['estaConcluida'] == 1,
    );
  }
}
