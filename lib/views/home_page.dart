import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'completed_tasks_page.dart';
import 'login_page.dart';
import '../services/firebase_service.dart';
import '../models/tarefa.dart';  // Add this import

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _taskController = TextEditingController();

  Future<void> _adicionarTarefa(String titulo) async {
    if (titulo.isNotEmpty) {
      try {
        await _firebaseService.addTask(Tarefa(
          id: '', // Firestore will generate this
          titulo: titulo,
          descricao: '',
          estaConcluida: false,
          dataCriacao: DateTime.now(),
        ));
        _taskController.clear();
      } catch (e) {
        debugPrint('Erro ao adicionar tarefa: $e');
      }
    }
  }

  Future<void> _alternarConclusao(DocumentSnapshot tarefa) async {
    try {
      bool novoEstado = !(tarefa.get('estaConcluida') ?? false);
      await _firebaseService.updateTask(Tarefa(
        id: tarefa.id,
        titulo: tarefa.get('titulo'),
        descricao: tarefa.get('descricao') ?? '',
        estaConcluida: novoEstado,
        dataCriacao: DateTime.parse(tarefa.get('dataCriacao')),
      ));
    } catch (e) {
      debugPrint('Erro ao alternar conclusão: $e');
    }
  }

  Future<void> _deletarTarefa(DocumentSnapshot tarefa) async {
    try {
      await _firebaseService.deleteTask(tarefa.id);
    } catch (e) {
      debugPrint('Erro ao deletar tarefa: $e');
    }
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
                stream: FirebaseFirestore.instance.collection('tarefas').snapshots(),
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
                          title: Text(tarefa['titulo'] ?? ''),
                          leading: Checkbox(
                            value: tarefa['estaConcluida'] ?? false,
                            onChanged: (bool? value) {
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
