import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tarefa.dart';

class FirebaseService {
  final CollectionReference tarefasCollection = FirebaseFirestore.instance.collection('tarefas');

  Future<void> addTask(Tarefa tarefa) {
    return tarefasCollection.add(tarefa.toMap());
  }

  Future<void> updateTask(Tarefa tarefa) {
    return tarefasCollection.doc(tarefa.id).update(tarefa.toMap());
  }

  Future<void> deleteTask(String id) {
    return tarefasCollection.doc(id).delete();
  }

  Future<List<Tarefa>> getTasks() async {
    final querySnapshot = await tarefasCollection.get();
    return querySnapshot.docs.map((doc) => Tarefa.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Tarefa>> getCompletedTasks() async {
    final querySnapshot = await tarefasCollection.where('estaConcluida', isEqualTo: true).get();
    return querySnapshot.docs.map((doc) => Tarefa.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}