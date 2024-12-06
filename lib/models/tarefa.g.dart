part of 'tarefa.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tarefa _$TarefaFromJson(Map<String, dynamic> json) => Tarefa(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      estaConcluida: json['estaConcluida'] as bool? ?? false,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
    );

Map<String, dynamic> _$TarefaToJson(Tarefa instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'estaConcluida': instance.estaConcluida,
      'dataCriacao': instance.dataCriacao.toIso8601String(),
    };