import 'package:flutter/material.dart';

class DatePicker {
  static Future<DateTime?> openDatePicker(
    BuildContext context,
    DateTime initialDate,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );
  }
}
