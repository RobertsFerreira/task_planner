import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  DateTime get toDate {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.parse(formatter.format(this));
  }

  String get toBrl {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }

  String get dayFormat {
    final formatter = DateFormat.d('pt_BR');
    return formatter.format(this).padLeft(2, '0');
  }

  String get dayWeekFormat {
    final formatter = DateFormat.yMMMMEEEEd('pt_BR');
    return formatter.format(this);
  }

  String get dayYearCurrentFormatter {
    final formatter = DateFormat.yMMMd('pt_BR');
    return formatter.format(this);
  }

  String get dayWeekly {
    final formatter = DateFormat('EEE', 'pt_BR');
    return formatter.format(this);
  }

  String get monthFormat {
    final formatter = DateFormat.MMMM('pt_BR');
    return formatter.format(this);
  }

  String weekNumberFormat(int weekNumber) {
    return DateFormat("'Semana' $weekNumber 'de' MMMM", 'pt_BR').format(this);
  }
}
