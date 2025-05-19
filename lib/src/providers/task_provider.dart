import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/models/task_model.dart';
import 'package:task_planner/src/shared/formatters/date_formatter.dart';

class TaskProvider with ChangeNotifier {
  TaskProvider() {
    _loadTasks();
  }

  List<Task> _tasks = [];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  bool _isLoading = true;

  List<Task> get tasks => _tasks;

  List<Task> get tasksCompleted =>
      _tasks.where((task) => task.status == TaskStatus.completed).toList();

  List<Task> get tasksPending =>
      _tasks.where((task) => task.status == TaskStatus.pending).toList();

  List<Task> get tasksInProgress =>
      _tasks.where((task) => task.status == TaskStatus.inProgress).toList();

  bool get isLoading => _isLoading;

  int get weekNumber {
    final firstDayOfMonth = DateTime(_selectedDay.year, _selectedDay.month, 1);
    final differenceDays = _selectedDay.difference(firstDayOfMonth).inDays;
    final weeksMonth = (differenceDays ~/ 7) + 1;
    return weeksMonth;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDay = date;
    notifyListeners();
  }

  void setDaySelect(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    notifyListeners();
  }

  void setFocusedDay(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  // Carrega as tarefas do armazenamento local
  Future<void> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString('tasks');

      if (tasksJson != null) {
        final List<dynamic> decodedTasks = jsonDecode(tasksJson);
        _tasks = decodedTasks.map((task) => Task.fromJson(task)).toList();
      }
    } catch (e) {
      debugPrint('Erro ao carregar tarefas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Salva as tarefas no armazenamento local
  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = jsonEncode(
        _tasks.map((task) => task.toJson()).toList(),
      );
      await prefs.setString('tasks', tasksJson);
    } catch (e) {
      debugPrint('Erro ao salvar tarefas: $e');
    }
  }

  // Adiciona uma nova tarefa
  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  // Atualiza uma tarefa existente
  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _saveTasks();
      notifyListeners();
    }
  }

  // Atualiza o status de uma tarefa
  void updateTaskStatus(String id, TaskStatus status) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(status: status);
      _saveTasks();
      notifyListeners();
    }
  }

  // Remove uma tarefa
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  // Obtém tarefas por intervalo de datas
  List<Task> getTasksByDateRange(DateTime startDate, DateTime endDate) {
    return _tasks.where((task) {
      final date = task.dueDate.toDate;
      final startDateFilter = startDate.toDate;
      final endDateFilter = endDate.toDate;
      final startWeek =
          date.isAfter(startDateFilter) ||
          date.isAtSameMomentAs(startDateFilter);
      final endWeek =
          date.isBefore(endDateFilter) || date.isAtSameMomentAs(endDateFilter);
      return startWeek && endWeek;
    }).toList();
  }

  // Obtém tarefas por status
  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  // Obtém tarefas por categoria
  List<Task> getTasksByCategory(TaskCategory category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  // Obtém tarefas para uma data específica
  List<Task> getTasksForDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    return _tasks.where((task) {
      final taskDate = DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );
      return taskDate.isAtSameMomentAs(targetDate);
    }).toList();
  }
}
