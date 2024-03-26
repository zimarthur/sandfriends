import 'package:intl/intl.dart';

import 'SFDateTime.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String getRawNumber() {
    RegExp regex = RegExp(r'\d+');
    Iterable<Match> matches = regex.allMatches(this);

    StringBuffer buffer = StringBuffer();

    for (Match match in matches) {
      buffer.write(match.group(0));
    }

    return buffer.toString();
  }
}

extension DoubleExtension on double {
  String formatPrice({bool showRS = true}) {
    return "${showRS ? "R\$" : ""}${this.toStringAsFixed(2).replaceAll(".", ",")}";
  }
}

extension IntExtension on int {
  String formatPrice({bool showRS = true}) {
    return "${showRS ? "R\$" : ""}$this,00";
  }
}

extension DateTimeExtension on DateTime {
  String formatDate({bool showYear = true}) {
    return DateFormat(showYear ? "dd/MM/yy" : "dd/MM").format(this);
  }

  String formatWrittenMonthYear() {
    return "${monthsPortuguese[month]}/$year";
  }
}
