import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>(); // Ensure TaskController is registered in GetX

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Concluídas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return ListView.builder(
            itemCount: taskController.tasks.length, // Ensure tasks is an observable list
            itemBuilder: (context, index) {
              final task = taskController.tasks[index];
              return ListTile(
                title: Text(task.title), // Access the title property of Task
              );
            },
          );
        }),
      ),
    );
  }
}