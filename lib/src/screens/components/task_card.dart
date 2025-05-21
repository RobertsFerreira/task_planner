import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/models/task_model.dart';
import 'package:task_planner/src/providers/task_form_dialog_provider.dart';
import 'package:task_planner/src/providers/task_provider.dart';
import 'package:task_planner/src/shared/formatters/date_formatter.dart';

import 'edit_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              task.dueDate.dayYearCurrentFormatter,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return ChangeNotifierProvider(
                        create: (_) => TaskFormDialogProvider(),
                        child: EditTaskDialog(task: task),
                      );
                    },
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Excluir Tarefa'),
                          content: const Text(
                            'Tem certeza que deseja excluir esta tarefa?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                taskProvider.deleteTask(task.id);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Excluir', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
          if (task.description != null && task.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(task.description!),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                Chip(
                  backgroundColor: task.priority.color.withValues(alpha: 0.1),
                  side: BorderSide(color: task.priority.color),
                  label: Text(
                    task.priority.description,
                    style: TextStyle(color: task.priority.color),
                  ),
                ),
                Chip(
                  backgroundColor: task.category.color.withValues(alpha: 0.1),
                  side: BorderSide(color: task.category.color),
                  label: Text(
                    task.category.description,
                    style: TextStyle(color: task.category.color),
                  ),
                ),
                Chip(
                  backgroundColor: task.status.color.withValues(alpha: 0.1),
                  side: BorderSide(color: task.status.color),
                  label: Text(
                    task.status.description,
                    style: TextStyle(color: task.status.color),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildActionButtons(context, taskProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, TaskProvider taskProvider) {
    if (task.status == TaskStatus.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.timelapse, color: Colors.blue),
              label: const Text(
                'Em Progresso',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                taskProvider.updateTaskStatus(task.id, TaskStatus.inProgress);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              label: const Text(
                'Concluir',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                taskProvider.updateTaskStatus(task.id, TaskStatus.completed);
              },
            ),
          ),
        ],
      );
    } else if (task.status == TaskStatus.inProgress) {
      return OutlinedButton.icon(
        icon: const Icon(Icons.check_circle, color: Colors.green),
        label: const Text('Concluir', style: TextStyle(color: Colors.green)),
        onPressed: () {
          taskProvider.updateTaskStatus(task.id, TaskStatus.completed);
        },
      );
    } else {
      return OutlinedButton.icon(
        icon: const Icon(Icons.refresh),
        label: const Text('Marcar como Pendente'),
        onPressed: () {
          taskProvider.updateTaskStatus(task.id, TaskStatus.pending);
        },
      );
    }
  }
}
