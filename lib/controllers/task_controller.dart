import '../models/task.dart' show Task;
import '../services/db_helper.dart';

class TaskController {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Task>> fetchTasks() async {
    return await _dbHelper.getTasks();
  }

  Future<void> addTask(String title) async {
    final task = Task(title: title);
    await _dbHelper.insertTask(task);
  }

  Future<void> updateTaskStatus(Task task, bool isCompleted) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isCompleted: isCompleted,
    );
    await _dbHelper.updateTask(updatedTask);
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
  }
}
