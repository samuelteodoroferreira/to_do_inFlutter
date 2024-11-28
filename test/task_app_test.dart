import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/main.dart';
import 'package:myapp/controllers/task_controller.dart';
import 'package:myapp/services/db_helper.dart';

void main() {
  group('DBHelper Tests', () {
    final dbHelper = DBHelper();

    test('should insert and retrieve tasks from the database', () async {
      // Prepare the task
      final task = Task(id: 1, title: 'Test Task', isCompleted: false);

      // Insert task
      await dbHelper.insertTask(task);

      // Retrieve tasks
      final tasks = await dbHelper.getTasks();

      expect(tasks.length, greaterThan(0));
      expect(tasks.first.title, equals('Test Task'));
    });

    test('should update task status in the database', () async {
      final task = Task(id: 1, title: 'Test Task', isCompleted: false);

      // Update the task
      await dbHelper.updateTask(task.copyWith(isCompleted: true));

      // Retrieve tasks
      final updatedTasks = await dbHelper.getTasks();
      expect(updatedTasks.first.isCompleted, equals(true));
    });

    test('should delete a task from the database', () async {
      // Delete the task
      await dbHelper.deleteTask(1);

      // Check tasks
      final tasks = await dbHelper.getTasks();
      expect(tasks, isEmpty);
    });
  });

  group('TaskController Tests', () {
    final controller = TaskController();

    test('should add a task and retrieve it via the controller', () async {
      // Add task
      await controller.addTask('New Task');

      // Fetch tasks
      final tasks = await controller.fetchTasks();
      expect(tasks.any((task) => task.title == 'New Task'), isTrue);
    });

    test('should toggle task completion via the controller', () async {
      // Prepare a task
      final tasks = await controller.fetchTasks();
      final task = tasks.first;

      // Toggle completion
      await controller.updateTaskStatus(task, !task.isCompleted);

      // Check updated status
      final updatedTasks = await controller.fetchTasks();
      expect(updatedTasks.first.isCompleted, equals(!task.isCompleted));
    });

    test('should delete a task via the controller', () async {
      // Delete task
      final tasks = await controller.fetchTasks();
      if (tasks.isNotEmpty) {
        await controller.deleteTask(tasks.first.id!);
      }

      // Check if deleted
      final remainingTasks = await controller.fetchTasks();
      expect(remainingTasks, isEmpty);
    });
  });

  group('Widget Tests', () {
    testWidgets('Should display "Sem tarefas" initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Check for initial message
      expect(find.text('Sem tarefas'), findsOneWidget);
    });

    testWidgets('Should add a new task and display it',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Add a task
      await tester.enterText(find.byType(TextField), 'Nova Tarefa');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify the task appears
      expect(find.text('Nova Tarefa'), findsOneWidget);
    });

    testWidgets('Should toggle task completion', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Add a task
      await tester.enterText(find.byType(TextField), 'Toggle Task');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Toggle completion
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Check if task is marked completed
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, isTrue);
    });

    testWidgets('Should delete a task', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Add a task
      await tester.enterText(find.byType(TextField), 'Delete Task');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Delete task
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // Verify task is removed
      expect(find.text('Delete Task'), findsNothing);
      expect(find.text('Sem tarefas'), findsOneWidget);
    });
  });
}
