import 'package:flutter/material.dart';
import 'package:task_planner/src/models/enum_task.dart';

class TagTask<T extends TaskEnumProperties> extends StatefulWidget {
  final T tag;
  const TagTask({super.key, required this.tag});

  @override
  State<TagTask> createState() => _TagTaskState();
}

class _TagTaskState extends State<TagTask> {
  @override
  Widget build(BuildContext context) {
    final tag = widget.tag;
    return Chip(
      backgroundColor: tag.color.withValues(alpha: 0.1),
      side: BorderSide(color: tag.color),
      label: Text(tag.description, style: TextStyle(color: tag.color)),
    );
    // Chip(
    //   backgroundColor: task.category.color.withValues(alpha: 0.1),
    //   side: BorderSide(color: task.category.color),
    //   label: Text(
    //     task.category.description,
    //     style: TextStyle(color: task.category.color),
    //   ),
    // ),
    // Chip(
    //   backgroundColor: task.status.color.withValues(alpha: 0.1),
    //   side: BorderSide(color: task.status.color),
    //   label: Text(
    //     'a${task.status.description}',
    //     style: TextStyle(color: task.status.color),
    //   ),
    // ),
  }
}
