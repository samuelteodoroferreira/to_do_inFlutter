import 'package:flutter/material.dart';

class Tarefa {

  String id;

  String titulo;

  bool estaConcluida;



  Tarefa({required this.id, required this.titulo, required this.estaConcluida});



  Map<String, dynamic> toMap() {

    return {

      'id': id,

      'titulo': titulo,

      'estaConcluida': estaConcluida,

    };

  }



  factory Tarefa.fromMap(Map<String, dynamic> map) {

    return Tarefa(

      id: map['id'],

      titulo: map['titulo'],

      estaConcluida: map['estaConcluida'],

    );

  }