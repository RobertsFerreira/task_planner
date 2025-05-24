import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalender<T> extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime, DateTime)? onDaySelected;
  final List<T> Function(DateTime)? getTasksForDate;
  final CalendarFormat calendarFormat;
  final Function(DateTime)? onPageChanged;
  final bool headerVisible;
  const CustomCalender({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    this.calendarFormat = CalendarFormat.month,
    this.onDaySelected,
    this.getTasksForDate,
    this.onPageChanged,
    this.headerVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        eventLoader: getTasksForDate,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
        ),
        locale: 'pt_BR',
        headerVisible: headerVisible,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
          weekendStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
