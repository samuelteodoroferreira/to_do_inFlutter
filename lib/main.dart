import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'views/completed_tasks_page.dart';
import 'controllers/task_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 18.0),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
      ),
      home: const LoginPage(),
      initialBinding: BindingsBuilder(() {
        Get.put(TaskController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const PaginaInicial()),
        GetPage(name: '/completed', page: () => const CompletedTasksPage()),
      ],
    );
  }
}

class TaskController {
}
