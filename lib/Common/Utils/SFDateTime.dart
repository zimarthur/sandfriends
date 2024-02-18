import 'package:intl/intl.dart';

import '../Model/Hour.dart';

List monthsPortuguese = [
  'Jan',
  'Fev',
  'Mar',
  'Abr',
  'Mai',
  'Jun',
  'Jul',
  'Ago',
  'Set',
  'Out',
  'Nov',
  'Dez'
];

List monthsPortugueseComplete = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro'
];
List<String> weekdayFull = [
  "Segunda-feira",
  "Terça-feira",
  "Quarta-feira",
  "Quinta-feira",
  "Sexta-feira",
  "Sábado",
  "Domingo",
];
List<String> weekday = [
  "segunda",
  "terça",
  "quarta",
  "quinta",
  "sexta",
  "sábado",
  "domingo",
];
List<String> weekdayRecurrent = [
  "segundas",
  "terças",
  "quartas",
  "quintas",
  "sextas",
  "sábados",
  "domingos",
];
List<String> weekdayShort = [
  "seg",
  "ter",
  "qua",
  "qui",
  "sex",
  "sáb",
  "dom",
];

DateTime stringToDateTime(String stringDateTime) {
  List<String> dateParts = stringDateTime.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);
  return DateTime(year, month, day);
}

DateTime getLastDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0);
}

bool isCurrentMonth(DateTime date) {
  return date.month == DateTime.now().month && date.year == DateTime.now().year;
}

int getDaysToEndOfMonth() {
  DateTime today = DateTime.now();
  return getLastDayOfMonth(today).day - today.day;
}

bool areInTheSameMonth(DateTime a, DateTime b) {
  return a.month == b.month && a.year == b.year;
}

bool areInTheSameDay(DateTime a, DateTime b) {
  return areInTheSameMonth(a, b) && a.day == b.day;
}

int getSFWeekday(int weekday) {
  if (weekday == 0) {
    return 6;
  } else {
    return weekday - 1;
  }
}

int nextWeekDay(int weekday) {
  if (weekday == 6) {
    return 0;
  }
  return weekday + 1;
}

int lastWeekDay(int weekday) {
  if (weekday == 0) {
    return 6;
  }
  return weekday - 1;
}

DateTime lastDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0);
}

int getSFMonthIndex(DateTime date) {
  return date.month - 1;
}

String getWeekdayTextFromDatetime(DateTime date) {
  return weekday[getSFWeekday(date.weekday)];
}

String getMonthYear(DateTime datetime) {
  return "${monthsPortuguese[datetime.month - 1]}/${datetime.year.toString().substring(datetime.year.toString().length - 2)}";
}

bool isInCurrentMonth(DateTime a) {
  return a.month == DateTime.now().month && a.year == DateTime.now().year;
}

bool isHourPast(DateTime date, Hour hour) {
  DateTime fullDateTime = DateTime(date.year, date.month, date.day,
      DateFormat('HH:mm').parse("${hour.hourString}").hour);

  return fullDateTime.isBefore(DateTime.now());
}
