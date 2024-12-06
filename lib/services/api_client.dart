import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/tarefa.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://firestore.googleapis.com/v1/projects/estudos-441916/databases/(default)/documents")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/tarefas")
  Future<List<Tarefa>> getTasks();

  @POST("/tarefas")
  Future<Tarefa> createTask(@Body() Tarefa task);

  @PUT("/tarefas/{id}")
  Future<Tarefa> updateTask(@Path() String id, @Body() Tarefa task);

  @DELETE("/tarefas/{id}")
  Future<void> deleteTask(@Path() String id);

  @GET("/tarefas/{id}")
  Future<Tarefa> getTaskById(@Path() String id);
}