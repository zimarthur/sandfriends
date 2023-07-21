String? validateCVV(String? value) {
  if (value == null || value.isEmpty) {
    return "digite o cvv";
  }
  if (value.length < 3 || value.length > 4) {
    return "cvv inválido";
  }
  return null;
}

String? validateCreditCardDate(String? value) {
  if (value == null || value.isEmpty) {
    return "digite a data";
  }
  if (value.length != 7) {
    return "MM/AAAA";
  }
  int year;
  int month;
  if (value.contains(RegExp(r'(/)'))) {
    var split = value.split(RegExp(r'(/)'));

    month = int.parse(split[0]);
    year = int.parse(split[1]);

    DateTime? parsedDatetime = DateTime.tryParse("$year-$month-01");
    if (month > 12) {
      return "data inválida";
    } else {
      if ((year < DateTime.now().year) ||
          (year == DateTime.now().year && month < DateTime.now().month)) {
        return "cartão expirado";
      } else {
        return null;
      }
    }
  } else {
    return "formato inválido";
  }
}

String? validateCardNum(String? input) {
  if (input == null || input.isEmpty) {
    return "digite o número do cartão";
  }
  input = input.replaceAll(RegExp(r"[^0-9]"), '');
  if (input.length < 8) {
    return "cartão inválido";
  }
  int sum = 0;
  int length = input.length;
  for (var i = 0; i < length; i++) {
    // get digits in reverse order
    int digit = int.parse(input[length - i - 1]);
// every 2nd number multiply with 2
    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }
  if (sum % 10 == 0) {
    return null;
  }
  return "cartão inválido";
}
