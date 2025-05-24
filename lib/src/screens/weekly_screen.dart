import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/screens/components/calendars/custom_calender.dart';
import 'package:task_planner/src/screens/components/states/empty_state.dart';
import 'package:task_planner/src/screens/components/tasks/task_card.dart';
import 'package:task_planner/src/shared/formatters/date_formatter.dart';
import 'package:task_planner/src/shared/formatters/double_formatter.dart';

import '../providers/task_provider.dart';

class WeeklyScreen extends StatefulWidget {
  const WeeklyScreen({super.key});

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  late DateTime _startOfWeek;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final selectedDay = taskProvider.selectedDay;
    final focusedDay = taskProvider.focusedDay;
    final selectedDayTasks = taskProvider.getTasksForDate(selectedDay);

    // Calcular o inicio da semana para o título
    if (focusedDay.weekday == DateTime.sunday) {
      _startOfWeek = focusedDay.subtract(Duration(days: 0));
    } else {
      _startOfWeek = focusedDay.subtract(Duration(days: focusedDay.weekday));
    }

    // Calcular o fim da semana para o título
    final endOfWeek = _startOfWeek.add(const Duration(days: 6));

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        focusedDay.weekNumberFormat(
                          context.read<TaskProvider>().weekNumber,
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_startOfWeek.dayFormat} - ${endOfWeek.dayFormat} ${endOfWeek.monthFormat}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        final newFocusedDay = focusedDay.subtract(
                          const Duration(days: 7),
                        );
                        taskProvider.setDaySelect(focusedDay, newFocusedDay);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        final newFocusedDay = focusedDay.subtract(
                          const Duration(days: 7),
                        );
                        taskProvider.setDaySelect(focusedDay, newFocusedDay);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomCalender(
            selectedDay: selectedDay,
            focusedDay: focusedDay,
            calendarFormat: CalendarFormat.week,
            onDaySelected: taskProvider.setDaySelect,
            onPageChanged: taskProvider.setFocusedDay,
            getTasksForDate: taskProvider.getTasksForDate,
          ),
          const SizedBox(height: 16),
          _buildWeekSummary(context, taskProvider),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Tarefas para ${selectedDay.dayWeekFormat}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          selectedDayTasks.isEmpty
              ? const EmptyState(
                title: 'Nenhuma tarefa para este dia',
                description:
                    'Adicione uma nova tarefa para começar a organizar seu dia.',
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: selectedDayTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(task: selectedDayTasks[index]);
                },
              ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWeekSummary(BuildContext context, TaskProvider taskProvider) {
    // Calcular o início e fim da semana
    final endOfWeek = _startOfWeek.add(const Duration(days: 6));

    // Obter todas as tarefas da semana
    final weekTasks = taskProvider.getTasksByDateRange(_startOfWeek, endOfWeek);

    // Calcular estatísticas
    final totalTasks = weekTasks.length;

    // Filtrar tarefas por status
    final completedTasks = taskProvider.tasksCompleted.length;
    final inProgressTasks = taskProvider.tasksInProgress.length;
    final pendingTasks = taskProvider.tasksPending.length;

    // Calcular porcentagem de conclusão
    final completionPercentage =
        totalTasks > 0.0 ? (completedTasks / totalTasks * 100) : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo da Semana',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  totalTasks.toString(),
                  'Total',
                  Icons.list_alt,
                ),
                _buildStatItem(
                  context,
                  completedTasks.toString(),
                  'Concluídas',
                  Icons.check_circle,
                  color: TaskStatus.completed.color,
                ),
                _buildStatItem(
                  context,
                  inProgressTasks.toString(),
                  'Em Progresso',
                  Icons.timelapse,
                  color: TaskStatus.inProgress.color,
                ),
                _buildStatItem(
                  context,
                  pendingTasks.toString(),
                  'Pendentes',
                  Icons.pending_actions,
                  color: TaskStatus.pending.color,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progresso: ${completionPercentage.toPercent}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$completedTasks/$totalTasks'),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                    minHeight: 10,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completionPercentage >= 75
                          ? Colors.green
                          : completionPercentage >= 50
                          ? Colors.lightGreen
                          : completionPercentage >= 25
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
