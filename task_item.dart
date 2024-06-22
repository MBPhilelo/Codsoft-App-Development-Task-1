import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_modal.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class TaskItem extends StatelessWidget {
  final Task task;
  final Function onToggleCompletion;
  final Function onDelete;
  final Function onEdit;

  TaskItem({
    required this.task,
    required this.onToggleCompletion,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Format the due date
    final String formattedDueDate = DateFormat('yyyy-MM-dd').format(task.dueDate);

    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description),
          Text('Due: $formattedDueDate'),
          Text('Priority: ${task.priority == 1 ? 'High' : task.priority == 2 ? 'Medium' : 'Low'}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              task.completed ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onPressed: () => onToggleCompletion(task.id),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddTaskModal(
                task: task,
                onAddTask: (title, description, dueDate, priority) {
                  final updatedTask = Task(
                    id: task.id,
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    priority: priority,
                    completed: task.completed,
                  );
                  onEdit(updatedTask);
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(task.id),
          ),
        ],
      ),
    );
  }
}
