import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'api_client.dart';
import '../models/tarefa.dart';
import 'dart:developer' as developer;
import 'package:logger/logger.dart';

class FirebaseService {
  late final ApiClient _apiClient;
  final CollectionReference tarefasCollection = FirebaseFirestore.instance.collection('tarefas');
  final logger = Logger();
  
  int _readOperations = 0;
  int _writeOperations = 0;

  int get readOperations => _readOperations;
  int get writeOperations => _writeOperations;

  FirebaseService() {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
    ));
    _apiClient = ApiClient(dio);
  }

  Future<void> addTask(Tarefa tarefa) async {
    try {
      await _apiClient.createTask(tarefa);
      _writeOperations++;
      _logOperation('Escrita', 'Adição de tarefa');
    } catch (e) {
      _logOperation('Erro', 'Falha ao adicionar tarefa: $e');
      rethrow;
    }
  }

  Future<void> updateTask(Tarefa tarefa) async {
    try {
      await _apiClient.updateTask(tarefa.id, tarefa);
      _writeOperations++;
      _logOperation('Escrita', 'Atualização de tarefa');
    } catch (e) {
      _logOperation('Erro', 'Falha ao atualizar tarefa: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _apiClient.deleteTask(id);
      _writeOperations++;
      _logOperation('Escrita', 'Remoção de tarefa');
    } catch (e) {
      _logOperation('Erro', 'Falha ao remover tarefa: $e');
      rethrow;
    }
  }

  Future<List<Tarefa>> getTasks() async {
    try {
      final tasks = await _apiClient.getTasks();
      _readOperations++;
      _logOperation('Leitura', 'Busca de todas as tarefas');
      return tasks;
    } catch (e) {
      _logOperation('Erro', 'Falha ao buscar tarefas: $e');
      rethrow;
    }
  }

  Future<List<Tarefa>> getCompletedTasks() async {
    final querySnapshot = await tarefasCollection.where('estaConcluida', isEqualTo: true).get();
    _readOperations++;
    _logOperation('Leitura', 'Busca de tarefas concluídas');
    return querySnapshot.docs.map((doc) => Tarefa.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  void _logOperation(String tipo, String descricao) {
    developer.log(
      '$tipo: $descricao',
      name: 'FirebaseOperations',
      time: DateTime.now(),
    );
    developer.log(
      'Total de operações - Leitura: $_readOperations, Escrita: $_writeOperations',
      name: 'FirebaseOperations',
    );
  }

  void resetCounters() {
    _readOperations = 0;
    _writeOperations = 0;
  }

  void printCounters() {
    logger.i('Leituras: $_readOperations');
    logger.i('Escritas: $_writeOperations');
  }
}