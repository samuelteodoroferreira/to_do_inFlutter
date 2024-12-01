import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/tarefa.dart';
import 'package:myapp/services/db_helper.dart';

void main() {
  group('Testes do DBHelper', () {
    final dbHelper = DBHelper();

    test('deve inserir e recuperar tarefas do banco de dados', () async {
      // Preparar a tarefa
      final tarefa = Tarefa(id: 1, titulo: 'Tarefa de Teste', estaConcluida: false);

      // Inserir tarefa
      await dbHelper.insertTask(tarefa);

      // Recuperar tarefas
      final tarefas = await dbHelper.getTasks();
      expect(tarefas.isNotEmpty, isTrue);
      expect(tarefas.first.titulo, 'Tarefa de Teste');
    });

    testWidgets('Deve alternar a conclusão de uma tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(const MeuApp());

      // Adicionar uma tarefa
      await tester.enterText(find.byType(TextField), 'Alternar Conclusão');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Alternar conclusão
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Verificar se a tarefa está marcada como concluída
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, isTrue);
    });

    testWidgets('Deve deletar uma tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(const MeuApp());

      // Adicionar uma tarefa
      await tester.enterText(find.byType(TextField), 'Deletar Tarefa');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Deletar tarefa
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // Verificar se a tarefa foi removida
      expect(find.text('Deletar Tarefa'), findsNothing);
    });
  });
}
