import 'package:intl/intl.dart';

extension DoubleExt on double {
  String get toPercent {
    final percent = this / 100;
    final formatter = NumberFormat.percentPattern('pt_BR');
    return formatter.format(percent);
  }
}
