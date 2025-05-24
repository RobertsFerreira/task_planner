import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/screens/components/calendars/custom_calender.dart';
import 'package:task_planner/src/screens/components/states/empty_state.dart';
import 'package:task_planner/src/screens/components/tasks/task_card.dart';
import 'package:task_planner/src/shared/formatters/date_formatter.dart';

import '../providers/task_provider.dart';

class MonthlyScreen extends StatefulWidget {
  const MonthlyScreen({super.key});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final selectedDay = taskProvider.selectedDay;
    final focusedDay = taskProvider.focusedDay;
    final selectedDayTasks = taskProvider.getTasksForDate(selectedDay);

    return SingleChildScrollView(
      child: Column(
        children: [
          CustomCalender(
            focusedDay: focusedDay,
            selectedDay: selectedDay,
            onDaySelected: taskProvider.setDaySelect,
            getTasksForDate: taskProvider.getTasksForDate,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Tarefas para ${selectedDay.toBrl}',
                  style: const TextStyle(
                    fontSize: 18,
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
                padding: const EdgeInsets.all(8),
                itemCount: selectedDayTasks.length,
                itemBuilder: (context, index) {
                  final task = selectedDayTasks.elementAt(index);
                  return TaskCard(task: task);
                },
              ),
        ],
      ),
    );
  }
}
