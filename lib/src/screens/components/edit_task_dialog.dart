import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/models/task_model.dart';
import 'package:task_planner/src/providers/task_provider.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TaskPriority _priority;
  late TaskCategory _category;
  late TaskStatus _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
    _selectedDate = widget.task.dueDate;
    _priority = widget.task.priority;
    _category = widget.task.category;
    _status = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
        dueDate: _selectedDate,
        priority: _priority,
        category: _category,
        status: _status,
        createdAt: widget.task.createdAt,
      );

      taskProvider.updateTask(widget.task.id, updatedTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Tarefa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Vencimento',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat.yMMMd('pt_BR').format(_selectedDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  border: OutlineInputBorder(),
                ),
                value: _priority,
                items:
                    TaskPriority.values.map((priority) {
                      String label;
                      switch (priority) {
                        case TaskPriority.low:
                          label = 'Baixa';
                          break;
                        case TaskPriority.medium:
                          label = 'Média';
                          break;
                        case TaskPriority.high:
                          label = 'Alta';
                          break;
                      }
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(label),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskCategory>(
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                value: _category,
                items:
                    TaskCategory.values.map((category) {
                      String label;
                      switch (category) {
                        case TaskCategory.work:
                          label = 'Trabalho';
                          break;
                        case TaskCategory.personal:
                          label = 'Pessoal';
                          break;
                        case TaskCategory.health:
                          label = 'Saúde';
                          break;
                        case TaskCategory.education:
                          label = 'Educação';
                          break;
                        case TaskCategory.other:
                          label = 'Outro';
                          break;
                      }
                      return DropdownMenuItem(
                        value: category,
                        child: Text(label),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: _status,
                items:
                    TaskStatus.values.map((status) {
                      String label;
                      switch (status) {
                        case TaskStatus.pending:
                          label = 'Pendente';
                          break;
                        case TaskStatus.inProgress:
                          label = 'Em Progresso';
                          break;
                        case TaskStatus.completed:
                          label = 'Concluída';
                          break;
                      }
                      return DropdownMenuItem(
                        value: status,
                        child: Text(label),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Salvar Alterações'),
        ),
      ],
    );
  }
}
