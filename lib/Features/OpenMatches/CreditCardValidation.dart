String? validateCardNumWithLuhnAlgorithm(String input) {
  if (input.isEmpty) {
    return "Digite o número do cartão";
  }

  input = input.replaceAll(new RegExp(r'[^0-9]'), '');
  ;

  if (input.length < 8) {
    // No need to even proceed with the validation if it's less than 8 characters
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
