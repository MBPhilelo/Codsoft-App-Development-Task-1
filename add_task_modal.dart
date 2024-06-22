import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskModal extends StatefulWidget {
  final Function(String, String, DateTime, int) onAddTask;
  final Task? task;

  AddTaskModal({required this.onAddTask, this.task});

  @override
  _AddTaskModalState createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  int _priority = 2;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add New Task' : 'Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          ListTile(
            title: Text('Due Date'),
            trailing: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _dueDate) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
            ),
            subtitle: Text("${_dueDate.toLocal()}".split(' ')[0]),
          ),
          ListTile(
            title: Text('Priority'),
            trailing: DropdownButton<int>(
              value: _priority,
              items: [
                DropdownMenuItem(child: Text('High'), value: 1),
                DropdownMenuItem(child: Text('Medium'), value: 2),
                DropdownMenuItem(child: Text('Low'), value: 3),
              ],
              onChanged: (value) {
                setState(() {
                  _priority = value ?? 2;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onAddTask(
              _titleController.text,
              _descriptionController.text,
              _dueDate,
              _priority,
            );
            Navigator.of(context).pop();
          },
          child: Text(widget.task == null ? 'Add' : 'Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

