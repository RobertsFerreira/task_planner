import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/models/enum_task.dart';
import 'package:task_planner/src/providers/task_form_dialog_provider.dart';
import 'package:task_planner/src/shared/components/dropdown/custom_dropdown.dart';
import 'package:task_planner/src/shared/components/textfield/custom_textfield.dart';
import 'package:task_planner/src/shared/formatters/date_formatter.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  @override
  Widget build(BuildContext context) {
    final dialogProvider = context.read<TaskFormDialogProvider>();
    return AlertDialog(
      title: const Text('Adicionar Nova Tarefa'),
      content: SingleChildScrollView(
        child: Form(
          key: dialogProvider.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Titulo',
                controller: dialogProvider.titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Descrição',
                controller: dialogProvider.descriptionController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => dialogProvider.selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Vencimento',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dialogProvider.selectedDate.dayYearCurrentFormatter),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomDropdown<TaskPriority>(
                label: 'Prioridade',
                onChanged: dialogProvider.setPriority,
                value: dialogProvider.priority,
                items:
                    TaskPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.description),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              CustomDropdown<TaskCategory>(
                label: 'Categoria',
                onChanged: dialogProvider.setCategory,
                value: dialogProvider.category,
                items:
                    TaskCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.description),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              CustomDropdown<TaskStatus>(
                label: 'Status',
                onChanged: dialogProvider.setStatus,
                value: dialogProvider.status,
                items:
                    TaskStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.description),
                      );
                    }).toList(),
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
            dialogProvider.submitForm(context);
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
