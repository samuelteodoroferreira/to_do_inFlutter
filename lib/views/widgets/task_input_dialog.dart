import 'package:flutter/material.dart';

class TaskInputDialog extends StatelessWidget {
  final Function(String) onSubmit;

  const TaskInputDialog({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Add a Task',
          suffixIcon: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              onSubmit(_controller.text);
              _controller.clear();
            },
          ),
        ),
      ),
    );
  }
}
