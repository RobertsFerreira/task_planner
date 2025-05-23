import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/models/task_model.dart';
import 'package:task_planner/src/providers/task_provider.dart';
import 'package:task_planner/src/screens/components/date_picker.dart';
import 'package:uuid/uuid.dart';

class TaskFormDialogProvider with ChangeNotifier {
  bool _isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TaskPriority _priority = TaskPriority.low;
  TaskCategory _category = TaskCategory.personal;
  TaskStatus _status = TaskStatus.pending;
  Task editTask = Task.empty();

  void loadFromTask(Task task) {
    titleController.text = task.title;
    descriptionController.text = task.description ?? '';
    _selectedDate = task.dueDate;
    _priority = task.priority;
    _category = task.category;
    _status = task.status;
    editTask = task;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  DateTime get selectedDate => _selectedDate;
  TaskPriority get priority => _priority;
  TaskCategory get category => _category;
  TaskStatus get status => _status;

  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setPriority(TaskPriority? priority) {
    if (priority == null) return;
    _priority = priority;
    notifyListeners();
  }

  void setCategory(TaskCategory? category) {
    if (category == null) return;
    _category = category;
    notifyListeners();
  }

  void setStatus(TaskStatus? status) {
    if (status == null) return;
    _status = status;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await DatePicker.openDatePicker(
      context,
      _selectedDate,
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  void submitForm(BuildContext context) {
    _setLoading(true);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (!formKey.currentState!.validate()) {
      _setLoading(false);
      return;
    }
    if (editTask.id.isEmpty) {
      _createNewTask(taskProvider);
    } else {
      _updateTask(taskProvider);
    }

    _setLoading(false);
  }

  void _createNewTask(TaskProvider taskProvider) {
    final newTask = Task(
      id: const Uuid().v4(),
      title: titleController.text,
      description: descriptionController.text,
      dueDate: _selectedDate,
      priority: _priority,
      category: _category,
      status: _status,
      createdAt: DateTime.now(),
    );
    taskProvider.addTask(newTask);
  }

  void _updateTask(TaskProvider taskProvider) {
    final updatedTask = Task(
      id: editTask.id,
      title: titleController.text,
      description: descriptionController.text,
      dueDate: _selectedDate,
      priority: _priority,
      category: _category,
      status: _status,
      createdAt: editTask.createdAt,
    );
    taskProvider.updateTask(editTask.id, updatedTask);
  }
}
