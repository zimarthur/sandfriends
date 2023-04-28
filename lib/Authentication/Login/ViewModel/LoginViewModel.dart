import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../Utils/PageStatus.dart';
import '../Repository/LoginRepoImp.dart';

class LoginViewModel extends ChangeNotifier {
  final _loginRepo = LoginRepoImp();

  PageStatus pageStatus = PageStatus.LOADING;
  String modalTitle = "";
  String modalDescription = "";
  VoidCallback modalCallback = () {};

  String titleText = "Login";

  void goToLoginSignup(BuildContext context) {
    context.goNamed(
      'login_signup',
    );
  }
}
