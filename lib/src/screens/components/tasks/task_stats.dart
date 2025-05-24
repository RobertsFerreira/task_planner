import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/providers/task_provider.dart';
import 'package:task_planner/src/shared/formatters/double_formatter.dart';

class TaskStats extends StatelessWidget {
  const TaskStats({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    final pendingTasks = taskProvider.getTasksByStatus(TaskStatus.pending);
    final inProgressTasks = taskProvider.getTasksByStatus(
      TaskStatus.inProgress,
    );
    final completedTasks = taskProvider.getTasksByStatus(TaskStatus.completed);

    final completionRate =
        tasks.isNotEmpty ? (completedTasks.length / tasks.length * 100) : 0.0;
    final inProgressRate =
        tasks.isNotEmpty ? (inProgressTasks.length / tasks.length * 100) : 0.0;

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        alignment: WrapAlignment.spaceBetween,
        children: [
          _buildStatCard(
            context,
            'Total de Tarefas',
            tasks.length.toString(),
            '${pendingTasks.length} pendentes, ${inProgressTasks.length} em progresso',
            Icons.list_alt,
          ),
          _buildStatCard(
            context,
            'Tarefas Concluídas',
            completedTasks.length.toString(),
            '${completionRate.toPercent} de todas as tarefas',
            Icons.check_circle_outline,
            color: TaskStatus.completed.color,
          ),
          const SizedBox(width: 8),
          _buildStatCard(
            context,
            'Em Progresso',
            inProgressTasks.length.toString(),
            '${inProgressRate.toPercent} de todas as tarefas',
            Icons.timelapse,
            color: TaskStatus.inProgress.color,
          ),
        ],
      ),
    );
  }

  double getWidth(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    if (currentWidth < 600) {
      // For small screens, use fix width
      return 600;
    } else {
      // For larger screens, use a terce of screen width
      return currentWidth * 0.3;
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon, {
    Color? color,
  }) {
    return SizedBox(
      width: getWidth(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Icon(
                    icon,
                    color:
                        color ?? Theme.of(context).textTheme.bodySmall?.color,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
