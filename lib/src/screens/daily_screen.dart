import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/models/task_model.dart';
import 'package:task_planner/src/screens/components/date_picker.dart';
import 'package:task_planner/src/screens/components/empty_state.dart';
import 'package:task_planner/src/screens/components/task_card.dart';
import 'package:task_planner/src/shared/formatters/date_formatter.dart';

import '../providers/task_provider.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final selectedDate = taskProvider.selectedDay;
    final tasks = taskProvider.getTasksForDate(selectedDate);

    // Organizar tarefas por prioridade
    final highPriorityTasks =
        tasks.where((task) => task.priority == TaskPriority.high).toList();
    final mediumPriorityTasks =
        tasks.where((task) => task.priority == TaskPriority.medium).toList();
    final lowPriorityTasks =
        tasks.where((task) => task.priority == TaskPriority.low).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDateSelector(context),
          tasks.isEmpty
              ? const EmptyState(
                title: 'Nenhuma tarefa para hoje',
                description:
                    'Adicione uma nova tarefa para começar a organizar seu dia.',
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      if (highPriorityTasks.isNotEmpty) ...[
                        _buildPrioritySection(
                          TaskPriority.high,
                          highPriorityTasks,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (mediumPriorityTasks.isNotEmpty) ...[
                        _buildPrioritySection(
                          TaskPriority.medium,
                          mediumPriorityTasks,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (lowPriorityTasks.isNotEmpty)
                        _buildPrioritySection(
                          TaskPriority.low,
                          lowPriorityTasks,
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    final provider = context.read<TaskProvider>();
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  provider.setSelectedDate(
                    provider.selectedDay.subtract(const Duration(days: 1)),
                  );
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Column(
                    children: [
                      Text(
                        provider.selectedDay.dayWeekFormat,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_isToday(provider.selectedDay))
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Hoje',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  provider.setSelectedDate(
                    provider.selectedDay.add(const Duration(days: 1)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySection(TaskPriority taskPriority, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: taskPriority.color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              taskPriority.description,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...tasks.map((task) => TaskCard(task: task)),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final provider = context.read<TaskProvider>();
    final DateTime initialDate = provider.selectedDay;
    final DateTime? picked = await DatePicker.openDatePicker(
      context,
      initialDate,
    );
    if (picked != null && picked != initialDate) {
      provider.setSelectedDate(picked);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(now, date);
  }
}
