String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "digite seu e-mail";
  } else if (RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return null;
  } else {
    return "e-mail inválido";
  }
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "digite sua senha";
  } else if (RegExp(r"^.{8,}").hasMatch(value)) {
    return null;
  } else {
    return "min. 8 caracteres";
  }
}

String? confirmPasswordValidator(String? password, String passwordRef) {
  if (password == null || password != passwordRef) {
    return "As senhas não estão iguais";
  } else {
    return null;
  }
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "informe seu nome";
  } else {
    return null;
  }
}

String? lastNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "informe seu sobrenome";
  } else {
    return null;
  }
}

String? genderValidator(String? value) {
  if (value == null || value == "") {
    return "informe seu gênero";
  } else {
    return null;
  }
}

String? phoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "digite um número";
  } else {
    final cleanValue = value.replaceAll(RegExp('[^0-9]'), '');
    if (cleanValue.length != 11 || int.tryParse(cleanValue) == null) {
      return "número inválido";
    } else {
      return null;
    }
  }
}

String? birthdayValidator(String? value) {
  if (value == null || value.isEmpty || value == "") {
    return null;
  } else {
    if (value.length != 10) {
      return "formato incorreto";
    } else {
      String convertedDatetime = formatedStringDate(value);
      if (DateTime.tryParse(convertedDatetime) == null) {
        return "data não existe";
      } else if (DateTime.parse(convertedDatetime).isAfter(DateTime.now())) {
        return "data inválida";
      } else {
        return null;
      }
    }
  }
}

String formatedStringDate(String rawDateTime) {
  String day = rawDateTime.substring(0, 2);
  String month = rawDateTime.substring(3, 5);
  String year = rawDateTime.substring(6, 10);
  return year + "-" + month + "-" + day;
}

String? heightValidator(String? value) {
  if (value == null || value.isEmpty || value == "") {
    return null;
  } else {
    if (double.tryParse(value) == null) {
      return "valor inválido";
    }
    double valueDouble = double.parse(value);
    if (valueDouble > 3 || valueDouble < 0) {
      return "valor inválido";
    } else {
      return null;
    }
  }
}

String phonenumberConverter(String rawPhonenumber) {
  return rawPhonenumber.substring(1, 4) +
      rawPhonenumber.substring(6, 11) +
      rawPhonenumber.substring(12, 16);
}

String? max255(String? value, String stringWhenEmpty) {
  if (value == null || value.isEmpty) {
    return stringWhenEmpty;
  } else if (value.length > 255) {
    return "Máx 255 caracteres";
  } else {
    return null;
  }
}

String? cpfValidator(String? value, String? onNull) {
  if (value == null || value.isEmpty) {
    return onNull ?? "digite o cpf";
  } else {
    final cleanValue = value.replaceAll(RegExp('[^0-9]'), '');
    if (cleanValue.length != 11 || int.tryParse(cleanValue) == null) {
      return "cpf inválido";
    } else {
      return null;
    }
  }
}

String? cepValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "digite o cep";
  } else {
    final cleanValue = value.replaceAll(RegExp('[^0-9]'), '');
    if (cleanValue.length != 8 || int.tryParse(cleanValue) == null) {
      return "cep inválido";
    } else {
      return null;
    }
  }
}

String? emptyCheck(String? value, String onNull) {
  if (value == null || value.isEmpty) {
    return onNull;
  } else {
    return null;
  }
}

String? rewardCodeValidator(String? value, String onNull) {
  if (value == null || value.isEmpty) {
    return onNull;
  } else if (value.length != 6) {
    return "O código deve ter 6 dígitos";
  } else {
    return null;
  }
}

String? cnpjValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Digite seu cnpj";
  } else {
    final cleanValue = value.replaceAll(RegExp('[^0-9]'), '');
    if (cleanValue.length != 14 || int.tryParse(cleanValue) == null) {
      return "Cnpj inválido";
    } else {
      return null;
    }
  }
}

String? phoneNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Digite um número";
  } else {
    final cleanValue = value.replaceAll(RegExp('[^0-9]'), '');
    if (cleanValue.length != 11 || int.tryParse(cleanValue) == null) {
      return "Número inválido";
    } else {
      return null;
    }
  }
}

String? lettersValidator(String? value, String onNull) {
  if (value == null || value.isEmpty) {
    return onNull;
  } else {
    if (RegExp(r"[^a-z ]", caseSensitive: false).allMatches(value).isNotEmpty) {
      return "Formato inválido";
    } else {
      return null;
    }
  }
}

String? priceValidator(String? value, String? onNull, {int? min, int? max}) {
  if (value == null || value.isEmpty) {
    return onNull ?? "Digite o valor";
  }
  int? parsed = int.tryParse(value);
  if (parsed == null) {
    return "Digite um número válido";
  }
  if (min != null && max != null) {
    if (parsed <= min || parsed > max) {
      return "Entre $min e $max";
    }
  }
  return null;
}
