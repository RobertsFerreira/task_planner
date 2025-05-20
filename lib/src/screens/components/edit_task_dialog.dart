import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/models/task_model.dart';
import 'package:task_planner/src/providers/task_form_dialog_provider.dart';
import 'package:task_planner/src/shared/formatters/date_formatter.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  @override
  void initState() {
    super.initState();
    final taskProvider = context.read<TaskFormDialogProvider>();
    taskProvider.loadFromTask(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.read<TaskFormDialogProvider>();
    return AlertDialog(
      title: const Text('Editar Tarefa'),
      content: SingleChildScrollView(
        child: Form(
          key: taskProvider.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: taskProvider.titleController,
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
                controller: taskProvider.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => taskProvider.selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Vencimento',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(taskProvider.selectedDate.dayYearCurrentFormatter),
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
                value: taskProvider.priority,
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
                onChanged: taskProvider.setPriority,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskCategory>(
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                value: taskProvider.category,
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
                onChanged: taskProvider.setCategory,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: taskProvider.status,
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
                onChanged: taskProvider.setStatus,
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
          onPressed: () {
            taskProvider.submitForm(context);
            Navigator.pop(context);
          },
          child: const Text('Salvar Alterações'),
        ),
      ],
    );
  }
}
