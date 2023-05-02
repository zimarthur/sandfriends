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

String? phoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "informe seu celular";
  } else {
    print(value.length);
    if (value.length != 16) {
      return "formato incorreto";
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

String? max255(String? value) {
  if (value!.isNotEmpty && value.length > 255) {
    return "Máx 255 caracteres";
  } else {
    return null;
  }
}
