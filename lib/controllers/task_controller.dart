import 'package:get/get.dart';

class Task {
  String title;
  DateTime creationTime;

  Task({required this.title, required this.creationTime});
}

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var completedTasks = <Task>[].obs;
  void addTask(Task task) {
    tasks.add(task);
  }

  void removeTask(int index) {
    tasks.removeAt(index);
  }

  void updateTask(int index, Task newTask) {
    tasks[index] = newTask;
  }

  void completeTask(int index) {
    completedTasks.add(tasks[index]);
    tasks.removeAt(index);
  }
}