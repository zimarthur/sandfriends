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

List weekDaysPortuguese = [
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
  'Domingo',
];

List shortWeekDaysPortuguese = [
  'Seg',
  'Ter',
  'Qua',
  'Qui',
  'Sex',
  'Sáb',
  'Dom',
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
