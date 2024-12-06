import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart' as mainApp;

void main() {
  group('Testes do App', () {
    testWidgets('Deve alternar a conclusão de uma tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(const mainApp.MeuApp());

      await tester.enterText(find.byType(TextField), 'Alternar Conclusão');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, isTrue);
    });

    testWidgets('Deve deletar uma tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(const mainApp.MeuApp());

      await tester.enterText(find.byType(TextField), 'Deletar Tarefa');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(find.text('Deletar Tarefa'), findsNothing);
    });
  });
}
