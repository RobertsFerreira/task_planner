import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/models/task_model.dart';
import 'package:task_planner/src/providers/task_provider.dart';
import 'package:uuid/uuid.dart';

class TaskFormDialogProvider with ChangeNotifier {
  bool _isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.personal;
  TaskStatus _status = TaskStatus.pending;

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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
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
    final newTask = Task(
      id: const Uuid().v4(),
      title: titleController.text,
      description:
          descriptionController.text.isEmpty
              ? null
              : descriptionController.text,
      dueDate: _selectedDate,
      priority: _priority,
      category: _category,
      status: _status,
      createdAt: DateTime.now(),
    );
    taskProvider.addTask(newTask);
    _setLoading(false);
  }
}
