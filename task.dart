class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  int priority; // 1-High, 2-Medium, 3-Low
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = 2,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'completed': completed,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
      completed: map['completed'],
    );
  }
}
