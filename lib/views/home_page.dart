import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'completed_tasks_page.dart';
import 'login_page.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Firestore instance
  final TextEditingController _taskController = TextEditingController();

  Future<void> _adicionarTarefa(String titulo) async {
    if (titulo.isNotEmpty) {
      await firestore.collection('tarefas').add({
        'titulo': titulo,
        'estaConcluida': false,
        'dataAdicionada': DateTime.now().toIso8601String(),
      });
      _taskController.clear();
    }
  }

  Future<void> _alternarConclusao(DocumentSnapshot tarefa) async {
    await firestore.collection('tarefas').doc(tarefa.id).update({
      'estaConcluida': !tarefa['estaConcluida'],
      'dataConcluida': !tarefa['estaConcluida'] ? DateTime.now().toIso8601String() : null,
    });
  }

  Future<void> _deletarTarefa(DocumentSnapshot tarefa) async {
    await firestore.collection('tarefas').doc(tarefa.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Get.to(() => const CompletedTasksPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Get.offAll(() => const LoginPage());
            },
          ),
        ],
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
                    _adicionarTarefa(_taskController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('tarefas').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar tarefas'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tarefas = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefas[index];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(tarefa['titulo']),
                          leading: Checkbox(
                            value: tarefa['estaConcluida'],
                            onChanged: (value) {
                              _alternarConclusao(tarefa);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deletarTarefa(tarefa);
                            },
                          ),
                        ),
                      );
                    },
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
