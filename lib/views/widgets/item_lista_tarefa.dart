import 'package:flutter/material.dart';
import '../../models/tarefa.dart';

class ItemListaTarefa extends StatelessWidget {
  final Tarefa tarefa;
  final Function(Tarefa) aoAlternarConclusao;
  final Function(Tarefa) aoDeletar;

  const ItemListaTarefa({
    super.key,
    required this.tarefa,
    required this.aoAlternarConclusao,
    required this.aoDeletar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        title: Text(
          tarefa.titulo, // Title is non-null
          style: TextStyle(
            decoration: tarefa.estaConcluida
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        leading: Checkbox(
          key: Key('checkbox_${tarefa.id}'),
          value: tarefa.estaConcluida,
          onChanged: (value) {
            aoAlternarConclusao(tarefa);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            aoDeletar(tarefa);
          },
        ),
      ),
    );
  }
}
