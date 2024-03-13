import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/PageStatus.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/View/OnboardingModal.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/Enum/EnumLoginSignupWidgets.dart';

import '../../../../../Common/Managers/LinkOpener/LinkOpenerManager.dart';
import '../../../../../Common/Managers/LocalStorage/LocalStorageManager.dart';
import '../../../../../Common/Model/User/UserComplete.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Sandfriends/Features/Authentication/CreateAccount/Repo/CreateAccountRepo.dart';
import '../../../../../Sandfriends/Features/Authentication/Login/Repository/LoginRepo.dart';
import '../../../../../Sandfriends/Features/Home/Repository/HomeRepo.dart';
import '../../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../../api/google_signin_api.dart';

class ProfileOverlayViewModel extends ChangeNotifier {
  final loginRepo = LoginRepo();
  final homeRepo = HomeRepo();
  final createAccountRepo = CreateAccountRepo();

  late bool mustCloseWhenDone;
  VoidCallback? close;
  ProfileOverlayViewModel({
    required this.mustCloseWhenDone,
    this.close,
  });

  EnumLoginSignupWidget currentWidget = EnumLoginSignupWidget.Login;
  PageStatus widgetStatus = PageStatus.OK;

  String? messageTitle;
  String? messageDescription;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailCreateAccountController = TextEditingController();
  final passwordCreateAccountController = TextEditingController();
  final passwordVerificationCreateAccountController = TextEditingController();

  final emailForgotPasswordController = TextEditingController();

  void goToForgotMyPassword() {
    currentWidget = EnumLoginSignupWidget.ForgotPassword;
    notifyListeners();
  }

  void goToLogin() {
    if (currentWidget == EnumLoginSignupWidget.Login) {
      widgetStatus = PageStatus.OK;
    } else {
      currentWidget = EnumLoginSignupWidget.Login;
    }
    notifyListeners();
  }

  void onTapForgotPassword(BuildContext context) {
    widgetStatus = PageStatus.LOADING;
    notifyListeners();
    loginRepo
        .forgotPassword(
      context,
      emailForgotPasswordController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        messageTitle = "Recuperação de senha enviada!";
        messageDescription = "Verifique seu email para escolher uma nova senha";
      } else {
        messageTitle = response.responseTitle;
        messageDescription = response.responseDescription;
      }
      widgetStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void goToCreateAccount() {
    currentWidget = EnumLoginSignupWidget.CreateAccount;
    notifyListeners();
  }

  void onTapCreateAccount(BuildContext context) {
    widgetStatus = PageStatus.LOADING;
    notifyListeners();
    createAccountRepo
        .createAccount(context, emailCreateAccountController.text,
            passwordCreateAccountController.text)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        messageTitle = "Sua conta foi criada";
        messageDescription = "Verifique seu email para confirmá-la";
      } else {
        messageTitle = response.responseTitle;
        messageDescription = response.responseDescription;
      }
      widgetStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void onTapLogin(BuildContext context) {
    widgetStatus = PageStatus.LOADING;
    notifyListeners();
    Provider.of<UserProvider>(context, listen: false)
        .setHasSearchUserData(false);
    loginRepo
        .login(context, emailController.text, passwordController.text)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        emailController.text = "";
        passwordController.text = "";
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        final responseUser = responseBody['User'];

        LocalStorageManager()
            .storeAccessToken(context, responseUser['AccessToken']);

        UserComplete loggedUser = UserComplete.fromJson(
          responseUser,
        );

        UserComplete? userFromGoogle =
            Provider.of<UserProvider>(context, listen: false).user;

        Provider.of<UserProvider>(context, listen: false).user = loggedUser;

        if (Provider.of<UserProvider>(context, listen: false)
            .userNeedsOnboarding()) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .addOverlayWidget(
            OnboardingModal(),
          );
        }
        getUserInfo(context);
      } else {
        messageTitle = response.responseTitle;
        messageDescription = response.responseDescription;
        widgetStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void getUserInfo(BuildContext context) {
    homeRepo
        .getUserInfo(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      null,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<UserProvider>(context, listen: false).clear();

        Provider.of<UserProvider>(context, listen: false)
            .receiveUserDataResponse(context, response.responseBody!);

        //canTapBackground = true;
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      }
      Provider.of<UserProvider>(context, listen: false)
          .setHasSearchUserData(true);
      if (mustCloseWhenDone) {
        close!();
      }
    });
  }

  void googleLogin(BuildContext context) async {
    widgetStatus = PageStatus.LOADING;
    notifyListeners();
    final user = await GoogleSignInApi.login();
  }

  void onTapProfile(BuildContext context) {
    close!();
    Navigator.pushNamed(context, '/jogador');
  }

  void onTapMatches(BuildContext context) {
    close!();

    Navigator.pushNamed(context, '/partidas');
  }

  void onTapCallSupport(BuildContext context) {
    close!();
    LinkOpenerManager().openSandfriendsWhatsApp(
      context,
    );
  }

  void onTapCallLogout(BuildContext context) {
    close!();
    Provider.of<UserProvider>(context, listen: false)
        .logoutUserProvider(context);
  }
}
