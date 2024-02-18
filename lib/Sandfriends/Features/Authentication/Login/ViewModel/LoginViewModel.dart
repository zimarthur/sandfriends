import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../LoadLogin/ViewModel/LoadLoginViewModel.dart';
import '../Repository/LoginRepo.dart';
import '../View/ForgotPasswordModal.dart';

class LoginViewModel extends StandardScreenViewModel {
  final loginRepo = LoginRepo();

  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();

  void login(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    loginRepo
        .login(context, emailController.text, passwordController.text)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        receiveLoginResponse(context, response.responseBody!);
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
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
    forgotPasswordEmailController.text = "";
    pageStatus = PageStatus.FORM;
    widgetForm = ForgotPasswordModal(viewModel: this);
    notifyListeners();
  }

  void requestForgotPassword(BuildContext context) {
    if (forgotPasswordFormKey.currentState!.validate()) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      loginRepo
          .forgotPassword(
        context,
        forgotPasswordEmailController.text,
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          modalMessage = SFModalMessage(
            title:
                "Feito! Enviamos um e-mail para você escolher uma nova senha",
            onTap: () {
              pageStatus = PageStatus.OK;
              notifyListeners();
            },
            isHappy: true,
          );
        } else {
          modalMessage = SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              pageStatus = PageStatus.FORM;
              widgetForm = ForgotPasswordModal(viewModel: this);
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

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }
}
