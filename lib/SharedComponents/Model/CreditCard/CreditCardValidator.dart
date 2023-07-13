String? validateCVV(String? value) {
  if (value == null || value.isEmpty) {
    return "Informe o cvv";
  }
  if (value.length < 3 || value.length > 4) {
    return "Cvv inválido";
  }
  return null;
}

String? validateCreditCardDate(String? value) {
  if (value == null || value.isEmpty) {
    return "Informe a data";
  }
  int year;
  int month;
  if (value.contains(RegExp(r'(/)'))) {
    var split = value.split(RegExp(r'(/)'));

    month = int.parse(split[0]);
    year = int.parse(split[1]);

    DateTime? parsedDatetime = DateTime.tryParse("$year-$month-01");
    if (parsedDatetime == null) {
      return "Data inválida";
    } else {
      if (parsedDatetime.isBefore(DateTime.now())) {
        return "Cartão expirado";
      } else {
        return null;
      }
    }
  } else {
    return "Formato inválido";
  }
}

String? validateCardNum(String? input) {
  if (input == null || input.isEmpty) {
    return "Informe o número do cartão";
  }
  input = input.replaceAll(RegExp(r"[^0-9]"), '');
  if (input.length < 8) {
    return "Cartão inválido";
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
  return "Cartão inválido";
}
