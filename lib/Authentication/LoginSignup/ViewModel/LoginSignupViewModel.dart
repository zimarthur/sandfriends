import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Authentication/LoginSignup/Repo/LoginSignupRepoImp.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../../Utils/PageStatus.dart';
import '../../../api/google_signin_api.dart';
import '../../../oldApp/models/user.dart';
import '../../../oldApp/providers/categories_provider.dart';

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
    try {
      final user = await GoogleSignInApi.login();

      if (user == null) {
        print("nenhuma conta selecionada");
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
      if (response == null) return;
      if (response.responseStatus == NetworkResponseStatus.success) {
        if (response.responseBody == null) return;
        Map<String, dynamic> responseBody = json.decode(response.responseBody!);
        final responseUserLogin = responseBody['UserLogin'];

        final newAccessToken = responseUserLogin['AccessToken'];
        const storage = FlutterSecureStorage();
        storage.write(key: "AccessToken", value: newAccessToken);

        if (responseUserLogin['IsNewUser']) {
          Provider.of<DataProvider>(context, listen: false).user =
              User(email: responseUserLogin['Email']);
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

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }
}
