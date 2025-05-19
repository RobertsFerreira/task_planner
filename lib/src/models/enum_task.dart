import 'package:flutter/material.dart';

enum TaskPriority {
  low(description: "Low priority", color: Colors.green),
  medium(description: "Medium priority", color: Colors.orange),
  high(description: "High priority", color: Colors.red);

  final String description;
  final Color color;
  const TaskPriority({required this.description, required this.color});

  static TaskPriority fromIndex(int index) {
    return TaskPriority.values[index];
  }
}

enum TaskCategory {
  work(description: "Work"),
  personal(description: "Personal"),
  health(description: "Health"),
  education(description: "Education"),
  other(description: "Other");

  final String description;
  const TaskCategory({required this.description});

  static TaskCategory fromIndex(int index) {
    return TaskCategory.values[index];
  }
}

enum TaskStatus {
  pending(description: "Pending", color: Colors.orange),
  inProgress(description: "In Progress", color: Colors.blue),
  completed(description: "Completed", color: Colors.green);

  final String description;
  final Color color;
  const TaskStatus({required this.description, required this.color});

  static TaskStatus fromIndex(int index) {
    return TaskStatus.values.elementAt(index);
  }
}
