import 'package:map_fields/map_fields.dart';
import 'package:task_planner/src/models/enum_task.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  factory Task.empty() {
    return Task(
      id: '',
      title: '',
      description: null,
      dueDate: DateTime.now(),
      priority: TaskPriority.medium,
      category: TaskCategory.personal,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  // Create a copy of the Task object
  // with modified properties
  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    TaskStatus? status,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  // Convert the Task object to a map
  // This is used for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'priority': priority.index,
      'category': category.index,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create a Task object from a map
  // This is used for deserialization
  factory Task.fromJson(Map<String, dynamic> json) {
    final MapFields mapFields = MapFields.load(json);

    return Task(
      id: mapFields.getString('id'),
      title: mapFields.getString('title'),
      description: mapFields.getString('description', ''),
      dueDate: mapFields.getDateTime('due_date'),
      priority: TaskPriority.fromIndex(mapFields.getInt('priority')),
      category: TaskCategory.fromIndex(mapFields.getInt('category')),
      status: TaskStatus.fromIndex(mapFields.getInt('status')),
      createdAt: mapFields.getDateTime('created_at'),
    );
  }
}
