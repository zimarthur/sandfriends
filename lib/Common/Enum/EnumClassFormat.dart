enum EnumClassFormat { Individual, Pair, Group }

EnumClassFormat classFormatFromInt(int value) {
  if (value == 1) {
    return EnumClassFormat.Individual;
  } else if (value == 2) {
    return EnumClassFormat.Pair;
  } else {
    return EnumClassFormat.Group;
  }
}

extension EnumClassFormatExtension on EnumClassFormat {
  String get icon {
    switch (this) {
      case EnumClassFormat.Individual:
        return 'assets/icon/user_singular.svg';
      case EnumClassFormat.Pair:
        return 'assets/icon/users.svg';
      case EnumClassFormat.Group:
        return 'assets/icon/user_group.svg';
    }
  }

  String get title {
    switch (this) {
      case EnumClassFormat.Individual:
        return 'Aula individual';
      case EnumClassFormat.Pair:
        return 'Aula em dupla';
      case EnumClassFormat.Group:
        return 'Aula em grupo';
    }
  }

  String get titleShort {
    switch (this) {
      case EnumClassFormat.Individual:
        return 'Individual';
      case EnumClassFormat.Pair:
        return 'Dupla';
      case EnumClassFormat.Group:
        return 'Grupo';
    }
  }

  int get value {
    switch (this) {
      case EnumClassFormat.Individual:
        return 1;
      case EnumClassFormat.Pair:
        return 2;
      case EnumClassFormat.Group:
        return 3;
    }
  }
}
