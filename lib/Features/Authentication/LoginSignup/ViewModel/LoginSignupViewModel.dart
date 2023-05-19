import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Authentication/LoadLogin/ViewModel/LoadLoginViewModel.dart';
import 'package:sandfriends/Features/Authentication/LoginSignup/Repo/LoginSignupRepoImp.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../../../Utils/PageStatus.dart';
import '../../../../api/google_signin_api.dart';
import '../../../../SharedComponents/Model/User.dart';
import '../../../../oldApp/providers/categories_provider.dart';

class LoginSignupViewModel extends ChangeNotifier {
  final loginSignupRepo = LoginSignupRempoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  void initGoogle() async {
    bool? isLoggedGoogle = await GoogleSignInApi.isLoggedIn();
    if (isLoggedGoogle != null && isLoggedGoogle == true) {
      await GoogleSignInApi.logout();
    }
  }

  void googleAccountSelector(BuildContext context) async {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    try {
      final user = await GoogleSignInApi.login();

      if (user == null) {
        print("nenhuma conta selecionada");
        pageStatus = PageStatus.OK;
        notifyListeners();
        return;
      } else {
        user.authentication.then((googleKey) {
          pageStatus = PageStatus.LOADING;
          notifyListeners();
          validateGoogleLogin(context, user.email);
        });
        initGoogle();
      }
    } catch (e) {
      initGoogle();
      modalMessage = SFModalMessage(
          message: e.toString(),
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: false);
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    }

    return null;
  }

  void validateGoogleLogin(BuildContext context, String email) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    loginSignupRepo.thirdPartyLogin(email).then((response) {
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

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }
}
