import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Authentication/LoadLogin/ViewModel/LoadLoginViewModel.dart';
import 'package:sandfriends/Features/Authentication/LoginSignup/Repo/LoginSignupRepoImp.dart';
import 'package:sandfriends/SharedComponents/Model/User.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../../Utils/PageStatus.dart';
import '../../../../api/google_signin_api.dart';

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
    loginSignupRepo.thirdPartyLogin(context, email).then((response) {
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
