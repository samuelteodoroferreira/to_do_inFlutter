import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'completed_tasks_page.dart';
import 'login_page.dart';
import '../services/firebase_service.dart';
import '../models/tarefa.dart';
import '../controllers/task_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();
    final TextEditingController textController = TextEditingController(); // Fix duplicate variable name

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Get.to(() => const CompletedTasksPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAll(() => const LoginPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Digite a tarefa'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  taskController.addTask(Task(title: textController.text, creationTime: DateTime.now()));
                  textController.clear();
                }
              },
              child: const Text('Adicionar Tarefa'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: taskController.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('Adicionado em: ${task.creationTime}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          taskController.completeTask(index);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
