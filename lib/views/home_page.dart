import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import 'widgets/item_lista_tarefa.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController _taskController = TextEditingController();

  void _adicionarTarefa(String titulo) {
    setState(() {
      _tarefas.add(Tarefa(titulo: titulo));
    });
    _taskController.clear();
  }

  void _alternarConclusao(Tarefa tarefa) {
    setState(() {
      tarefa.estaConcluida = !tarefa.estaConcluida;
    });
  }

  void _deletarTarefa(Tarefa tarefa) {
    setState(() {
      _tarefas.remove(tarefa);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Tarefas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: Key('task_input'),
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar Tarefa',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      _adicionarTarefa(_taskController.text);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  return ItemListaTarefa(
                    tarefa: _tarefas[index],
                    aoAlternarConclusao: _alternarConclusao,
                    aoDeletar: _deletarTarefa,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
