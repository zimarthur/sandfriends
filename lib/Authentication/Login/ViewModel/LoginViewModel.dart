import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Authentication/Login/View/ForgotPasswordModal.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/oldApp/models/user.dart';
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
      if (response == null) return;
      if (response.responseStatus == NetworkResponseStatus.success) {
        if (response.responseBody == null) return;
        Map<String, dynamic> responseBody = json.decode(response.responseBody!);
        final responseUser = responseBody['User'];

        final newAccessToken = responseUser['AccessToken'];
        const storage = FlutterSecureStorage();
        storage.write(key: "AccessToken", value: newAccessToken);

        if (responseUser['FirstName'] == null) {
          Provider.of<DataProvider>(context, listen: false).user =
              User(email: responseUser['Email']);
          context.goNamed('new_user_welcome');
        } else {
          final responseUser = responseBody['User'];
          final responseUserMatchCounter = responseBody['MatchCounter'];

          Provider.of<DataProvider>(context, listen: false).user =
              User.fromJson(responseUser);

          Provider.of<DataProvider>(context, listen: false)
              .user
              ?.matchCounterFromJson(
                responseUserMatchCounter,
                Provider.of<CategoriesProvider>(
                  context,
                  listen: false,
                ),
              );
          pageStatus = PageStatus.OK;
          notifyListeners();
          context.goNamed('home', params: {'initialPage': 'feed_screen'});
        }
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
        if (response == null) return;
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
    context.goNamed(
      'login_signup',
    );
  }
}