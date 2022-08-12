enum EnumSignupStatus { Success, Failed, AccountAlreadyExists }
enum EnumLoginStatus { Success, Failed }
enum EnumChangePasswordStatus {
  Success,
  WrongEmail,
  WrongPassword,
  NotConfirmedEmail
}
enum Sport { Beachtennis, futevolei, volei }

enum SearchFilter { Local, Date, Time }

extension ParseToString on Sport {
  String toShortString() {
    if (this == Sport.Beachtennis) {
      return 'Beach Tennis';
    } else if (this == Sport.futevolei) {
      return 'Futevôlei';
    } else {
      return 'Vôlei';
    }
  }
}

enum AppBarType { Primary, Secondary }

enum GenericStatus { Success, Failed }
