import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_modal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List tasksList = json.decode(tasksString);
      setState(() {
        _tasks = tasksList.map((task) => Task.fromMap(task)).toList();
      });
    }
  }

  _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksString = json.encode(_tasks.map((task) => task.toMap()).toList());
    prefs.setString('tasks', tasksString);
  }

  _addTask(String title, String description, DateTime dueDate, int priority) {
    final task = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
    );
    setState(() {
      _tasks.add(task);
    });
    _saveTasks();
  }

  _editTask(Task updatedTask) {
    setState(() {
      int index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    });
    _saveTasks();
  }

  _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    _saveTasks();
  }

  _toggleTaskCompletion(String id) {
    setState(() {
      int index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index].completed = !_tasks[index].completed;
      }
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return TaskItem(
            task: task,
            onToggleCompletion: _toggleTaskCompletion,
            onDelete: _deleteTask,
            onEdit: _editTask,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTaskModal(
            onAddTask: _addTask,
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
