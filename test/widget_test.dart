import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/views/login_page.dart';
import 'completed_tasks_page.dart';
import '../services/firebase_service.dart';
import '../controllers/task_controller.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '0',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();
    final TextEditingController textController = TextEditingController();

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
                  taskController.addTask(Tarefa(
                    title: textController.text,
                    creationTime: DateTime.now(),
                  ));
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
                      title: Text(task.title ?? 'Sem Título'),
                      subtitle: Text('Adicionado em: ${task.creationTime ?? 'Desconhecido'}'),
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

class Tarefa {
  String? title;
  DateTime? creationTime;

  Tarefa({this.title, this.creationTime});
}

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Concluídas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return ListView.builder(
            itemCount: taskController.completedTasks.length,
            itemBuilder: (context, index) {
              final task = taskController.completedTasks[index];
              return ListTile(
                title: Text(task.title ?? 'Sem Título'),
                subtitle: Text('Adicionado em: ${task.creationTime ?? 'Desconhecido'}'),
              );
            },
          );
        }),
      ),
    );
  }
}

class TaskController extends GetxController {
  final RxList<Tarefa> _tasks = <Tarefa>[].obs;
  final RxList<Tarefa> _completedTasks = <Tarefa>[].obs;

  List<Tarefa> get tasks => _tasks;
  List<Tarefa> get completedTasks => _completedTasks;

  void addTask(Tarefa task) {
    _tasks.add(task);
  }

  void completeTask(int index) {
    final task = _tasks[index];
    _completedTasks.add(task);
    _tasks.removeAt(index);
  }
}
