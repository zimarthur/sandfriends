import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Authentication/LoadLogin/ViewModel/LoadLoginViewModel.dart';
import 'package:sandfriends/Authentication/Login/View/ForgotPasswordModal.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/SharedPreferences.dart';
import 'package:sandfriends/SharedComponents/Model/User.dart';
import 'package:sandfriends/oldApp/widgets/Modal/SFModalMessageCopy.dart';

import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../../oldApp/providers/categories_provider.dart';
import '../Repository/LoginRepoImp.dart';

class LoginViewModel extends ChangeNotifier {
  final _loginRepo = LoginRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget modalForm = Container();

  String titleText = "Login";

  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();

  void login(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    _loginRepo
        .login(emailController.text, passwordController.text)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        receiveLoginResponse(context, response.responseBody!);
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage.toString(),
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: false,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void openForgotPasswordModal() {
    pageStatus = PageStatus.FORM;
    modalForm = ForgotPasswordModal(viewModel: this);
    notifyListeners();
  }

  void requestForgotPassword(BuildContext context) {
    if (forgotPasswordFormKey.currentState!.validate()) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      _loginRepo
          .forgotPassword(
        forgotPasswordEmailController.text,
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          modalMessage = SFModalMessage(
            message:
                "Feito! Enviamos um e-mail para você escolher uma nova senha",
            onTap: () {
              pageStatus = PageStatus.OK;
              notifyListeners();
            },
            isHappy: true,
          );
        } else {
          modalMessage = SFModalMessage(
            message: response.userMessage.toString(),
            onTap: () {
              pageStatus = PageStatus.FORM;
              modalForm = ForgotPasswordModal(viewModel: this);
              notifyListeners();
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          );
        }
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      });
    }
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }
}
