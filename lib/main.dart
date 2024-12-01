import 'package:flutter/material.dart';
import 'package:myapp/models/tarefa.dart';
import 'package:myapp/services/db_helper.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController _controller = TextEditingController();
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tarefas = await dbHelper.getTasks();
    setState(() {
      _tarefas = tarefas;
    });
  }

  Future<void> _addTask() async {
    final titulo = _controller.text;
    if (titulo.isNotEmpty) {
      final tarefa = Tarefa(titulo: titulo, estaConcluida: false);
      await dbHelper.insertTask(tarefa);
      _controller.clear();
      _loadTasks();
    }
  }

  Future<void> _toggleTaskCompletion(Tarefa tarefa) async {
    tarefa.estaConcluida = !tarefa.estaConcluida;
    await dbHelper.updateTask(tarefa);
    _loadTasks();
  }

  Future<void> _deleteTask(Tarefa tarefa) async {
    if (tarefa.id != null) {
      await dbHelper.deleteTask(tarefa.id!);
    }
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CompletedTasksPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nova Tarefa',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return ListTile(
                  title: Text(tarefa.titulo),
                  leading: Checkbox(
                    value: tarefa.estaConcluida,
                    onChanged: (value) {
                      _toggleTaskCompletion(tarefa);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteTask(tarefa);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Concluídas'),
      ),
      body: FutureBuilder<List<Tarefa>>(
        future: DBHelper().getCompletedTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar tarefas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa concluída'));
          } else {
            final tarefasConcluidas = snapshot.data!;
            return ListView.builder(
              itemCount: tarefasConcluidas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefasConcluidas[index];
                return ListTile(
                  title: Text(tarefa.titulo),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Implement your login logic here
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nome de usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
