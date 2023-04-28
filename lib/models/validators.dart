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

String? max255(String? value) {
  if (value!.isNotEmpty && value.length > 255) {
    return "Máx 255 caracteres";
  } else {
    return null;
  }
}
