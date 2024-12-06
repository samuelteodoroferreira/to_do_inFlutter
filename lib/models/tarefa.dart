import 'package:json_annotation/json_annotation.dart';

part 'tarefa.g.dart';

@JsonSerializable()
class Tarefa {
  final String id;
  final String titulo;
  final String descricao;
  final bool estaConcluida;
  final DateTime dataCriacao;
  DateTime? dataConclusao;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.estaConcluida = false,
    required this.dataCriacao,
    this.dataConclusao,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) => _$TarefaFromJson(json);

  Map<String, dynamic> toJson() => _$TarefaToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'estaConcluida': estaConcluida,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataConclusao': dataConclusao?.toIso8601String(),
    };
  }

  factory Tarefa.fromMap(String id, Map<String, dynamic> map) {
    return Tarefa(
      id: id,
      titulo: map['titulo'],
      descricao: map['descricao'],
      estaConcluida: map['estaConcluida'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
      dataConclusao: map['dataConclusao'] != null ? DateTime.parse(map['dataConclusao']) : null,
    );
  }
}