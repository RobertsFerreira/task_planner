import 'package:flutter/material.dart';

mixin TaskEnumProperties on Enum {
  String get description;
  Color get color;
}

enum TaskPriority with TaskEnumProperties {
  low(description: "Low priority", color: Colors.green),
  medium(description: "Medium priority", color: Colors.orange),
  high(description: "High priority", color: Colors.red);

  @override
  final String description;
  @override
  final Color color;
  const TaskPriority({required this.description, required this.color});

  static TaskPriority fromIndex(int index) {
    return TaskPriority.values[index];
  }
}

enum TaskCategory with TaskEnumProperties {
  work(description: "Work", color: Colors.blue),
  personal(description: "Personal", color: Colors.purple),
  health(description: "Health", color: Colors.teal),
  education(description: "Education", color: Colors.indigo),
  other(description: "Other", color: Colors.grey);

  @override
  final String description;
  @override
  final Color color;
  const TaskCategory({required this.description, required this.color});

  static TaskCategory fromIndex(int index) {
    return TaskCategory.values[index];
  }
}

enum TaskStatus with TaskEnumProperties {
  pending(description: "Pending", color: Colors.orange),
  inProgress(description: "In Progress", color: Colors.blue),
  completed(description: "Completed", color: Colors.green);

  @override
  final String description;
  @override
  final Color color;
  const TaskStatus({required this.description, required this.color});

  static TaskStatus fromIndex(int index) {
    return TaskStatus.values.elementAt(index);
  }
}
