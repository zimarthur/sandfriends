import 'package:flutter/material.dart';


class Login with ChangeNotifier {
  /*LoginStatus _loginStatus = LoginStatus.LogOff;

  LoginStatus get loginStatus => _loginStatus;

  set loginStatus(LoginStatus value) {
    _loginStatus = value;
    notifyListeners();
  }*/

  bool _isNewUser = false;

  bool get isNewUser => _isNewUser;

  set isNewUser(bool value) {
    _isNewUser = value;
    notifyListeners();
  }

  String? _emailConfirmationToken;
  String? get emailConfirmationToken => _emailConfirmationToken;
  set emailConfirmationToken(String? value) {
    _emailConfirmationToken = value;
  }

  String? _changePasswordToken;
  String? get changePasswordToken => _changePasswordToken;
  set changePasswordToken(String? value) {
    _changePasswordToken = value;
  }
}
