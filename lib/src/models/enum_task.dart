import 'package:flutter/material.dart';

mixin TaskEnumProperties on Enum {
  String get description;
  Color get color;
}

enum TaskPriority with TaskEnumProperties {
  low(description: "Baixa Prioridade", color: Colors.green),
  medium(description: "Média Prioridade", color: Colors.orange),
  high(description: "Alta Prioridade", color: Colors.red);

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
  work(description: "Trabalho", color: Colors.blue),
  personal(description: "Pessoal", color: Colors.purple),
  health(description: "Saúde", color: Colors.teal),
  education(description: "Educação", color: Colors.indigo),
  other(description: "Outros", color: Colors.grey);

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
  pending(description: "Pendente", color: Colors.orange),
  inProgress(description: "Em Progresso", color: Colors.blue),
  completed(description: "Completado", color: Colors.green);

  @override
  final String description;
  @override
  final Color color;
  const TaskStatus({required this.description, required this.color});

  static TaskStatus fromIndex(int index) {
    return TaskStatus.values.elementAt(index);
  }
}
