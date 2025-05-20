import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final String label;
  const CustomDropdown({
    super.key,
    required this.label,
    this.onChanged,
    this.value,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Selecione uma opção',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
