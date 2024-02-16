import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Authentication/LoadLogin/ViewModel/LoadLoginViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Authentication/LoginSignup/Repo/LoginSignupRepo.dart';
import 'package:sandfriends/Common/Model/User.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../api/google_signin_api.dart';

class LoginSignupViewModel extends StandardScreenViewModel {
  final loginSignupRepo = LoginSignupRempo();

  void initGoogle() async {
    bool? isLoggedGoogle = await GoogleSignInApi.isLoggedIn();
    if (isLoggedGoogle != null && isLoggedGoogle == true) {
      await GoogleSignInApi.logout();
    }
  }

  void appleAccountSelector(BuildContext context) async {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      pageStatus = PageStatus.LOADING;
      notifyListeners();
      String fullName = credential.familyName ?? "";
      String email = credential.email ?? "";
      Provider.of<UserProvider>(context, listen: false).user = User(
          email: email, accessToken: "", firstName: fullName, lastName: "");

      validateGoogleLogin(context, email, credential.userIdentifier);
    } catch (e) {
      print(e.toString());
      modalMessage = SFModalMessage(
          title: e.toString(),
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

  void googleAccountSelector(BuildContext context) async {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    try {
      final user = await GoogleSignInApi.login();

      if (user == null) {
        pageStatus = PageStatus.OK;
        notifyListeners();
        return;
      } else {
        user.authentication.then((googleKey) {
          pageStatus = PageStatus.LOADING;
          notifyListeners();
          String fullName = user.displayName.toString();
          int firstSpaceIndex = fullName.indexOf(" ");
          String firstName = "";
          String lastName = "";
          if (firstSpaceIndex != -1) {
            firstName = fullName.substring(0, firstSpaceIndex);
            lastName = fullName.substring(firstSpaceIndex + 1);
          } else {
            firstName = fullName;
          }
          if (firstName != "") {
            Provider.of<UserProvider>(context, listen: false).user = User(
                email: user.email,
                accessToken: "",
                firstName: firstName,
                lastName: lastName);
          }

          validateGoogleLogin(context, user.email, null);
        });
        initGoogle();
      }
    } catch (e) {
      print(e.toString());
      modalMessage = SFModalMessage(
          title: e.toString(),
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

  void validateGoogleLogin(
      BuildContext context, String email, String? appleToken) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    loginSignupRepo
        .thirdPartyLogin(context, email, appleToken)
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
}
