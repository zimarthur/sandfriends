import 'package:flutter/material.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../../Utils/PageStatus.dart';
import '../../LoadLogin/ViewModel/LoadLoginViewModel.dart';
import '../Repository/LoginRepoImp.dart';
import '../View/ForgotPasswordModal.dart';

class LoginViewModel extends ChangeNotifier {
  final loginRepo = LoginRepoImp();

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
    loginRepo
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
    forgotPasswordEmailController.text = "";
    pageStatus = PageStatus.FORM;
    modalForm = ForgotPasswordModal(viewModel: this);
    notifyListeners();
  }

  void requestForgotPassword(BuildContext context) {
    if (forgotPasswordFormKey.currentState!.validate()) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      loginRepo
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
