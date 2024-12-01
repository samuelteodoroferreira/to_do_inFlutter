import 'package:flutter/material.dart';

class DialogoEntradaTarefa extends StatelessWidget {
  final Function(String) aoEnviar;

  const DialogoEntradaTarefa({super.key, required this.aoEnviar});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text('Adicionar uma Tarefa'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Título da Tarefa',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            aoEnviar(controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
