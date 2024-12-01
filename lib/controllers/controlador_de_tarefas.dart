import '../models/tarefa.dart' show Tarefa;
import '../services/db_helper.dart';

class ControladorDeTarefas {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Tarefa>> buscarTarefas() async {
    return await _dbHelper.getTasks();
  }

  Future<void> adicionarTarefa(String titulo) async {
    final tarefa = Tarefa(titulo: titulo);
    await _dbHelper.insertTask(tarefa);
  }

  Future<void> atualizarStatusTarefa(Tarefa tarefa, bool estaConcluida) async {
    final tarefaAtualizada = Tarefa(
      id: tarefa.id,
      titulo: tarefa.titulo,
      estaConcluida: estaConcluida,
    );
    await _dbHelper.updateTask(tarefaAtualizada);
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
  }

  Future<void> atualizarTarefa(Tarefa tarefaAtualizada) async {
    await _dbHelper.updateTask(tarefaAtualizada);
  }
}
