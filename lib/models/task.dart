class Task {
  final int? id;
  final String title;
  final bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false});

  // Converte de Map (do banco de dados) para Task.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  // Converte de Task para Map (para o banco de dados).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
