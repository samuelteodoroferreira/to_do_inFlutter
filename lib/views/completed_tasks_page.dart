import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Concluídas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tarefas')
            .where('estaConcluida', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar tarefas'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa concluída'));
          } else {
            final tarefasConcluidas = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tarefasConcluidas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefasConcluidas[index];
                return ListTile(
                  title: Text(tarefa['titulo']),
                  subtitle: Text(
                    'Adicionada: ${tarefa['dataAdicionada']}\nConcluída: ${tarefa['dataConcluida']}',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}