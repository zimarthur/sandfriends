import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../LoadLogin/ViewModel/LoadLoginViewModel.dart';
import '../Repository/LoginRepo.dart';
import '../View/ForgotPasswordModal.dart';

class LoginViewModel extends ChangeNotifier {
  final loginRepo = LoginRepo();

  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController forgotPasswordEmailController =
      TextEditingController();

  void login(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    loginRepo
        .login(context, emailController.text, passwordController.text)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        receiveLoginResponse(context, response.responseBody!);
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {},
            isHappy: false,
          ),
        );
      }
    });
  }

  void openForgotPasswordModal(BuildContext context) {
    forgotPasswordEmailController.text = "";
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ForgotPasswordModal(viewModel: this),
    );
  }

  void requestForgotPassword(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    loginRepo
        .forgotPassword(
      context,
      forgotPasswordEmailController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title:
                "Feito! Enviamos um e-mail para você escolher uma nova senha",
            onTap: () {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .clearOverlays();
            },
            isHappy: true,
          ),
        );
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .addOverlayWidget(
                ForgotPasswordModal(viewModel: this),
              );
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
      }
    });
  }

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }
}
