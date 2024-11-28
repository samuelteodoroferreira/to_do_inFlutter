import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'widgets/task_list_tile.dart';
import 'widgets/task_input_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _controller = TaskController();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _controller.fetchTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _addTask(String title) async {
    await _controller.addTask(title);
    _loadTasks();
  }

  void _toggleTaskCompletion(Task task) async {
    await _controller.updateTaskStatus(task, !task.isCompleted);
    _loadTasks();
  }

  void _deleteTask(int id) async {
    await _controller.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador de Tarefas do Dia')),
      body: Column(
        children: [
          TaskInputDialog(onSubmit: _addTask),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskListTile(
                  task: task,
                  onToggleCompletion: _toggleTaskCompletion,
                  onDelete: _deleteTask,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
