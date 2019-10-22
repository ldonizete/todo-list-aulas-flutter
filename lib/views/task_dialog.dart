import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';

class TaskDialog extends StatefulWidget {
  final Task task;

  TaskDialog({this.task});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _priority;

  Task _currentTask = Task();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = Task.fromMap(widget.task.toMap());
    }

    _titleController.text = _currentTask.title;
    _descriptionController.text = _currentTask.description;
    _priority = _currentTask.priority;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
    _priority = "";
  }

   var _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: AlertDialog(
        title: Text(widget.task == null ? 'Nova tarefa' : 'Editar tarefas'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Título'),
              controller: _titleController,
              autofocus: true,
              validator: (text)
              {
                return text.isEmpty ? "Insere o título" : null;
              }
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Descrição'),
              controller: _descriptionController,
              autofocus: true,
              maxLines: 3,
              validator: (text)
              {
                return text.isEmpty ? "Insira a descrição" : null;
              },
            ),
            DropdownButton<String>(
              items: <String>['1','2','3','4','5'].map( (String valor)
                {
                  return new DropdownMenuItem<String>(
                    value: valor,
                    child: new Text(valor),
                  );
                }).toList(),
              onChanged: (String value) {
                setState(() {
                  _priority = value;
                });
              },
              hint: Text('Nível de prioridade'),
              value: _priority,
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Salvar'),
            onPressed: () {
              if (_keyForm.currentState.validate()) {
              _currentTask.title = _titleController.value.text;
              _currentTask.description = _descriptionController.text;
              _currentTask.priority = _priority;
              Navigator.of(context).pop(_currentTask);
              }
            },
          ),
        ],
      ),
    );
  }
}
