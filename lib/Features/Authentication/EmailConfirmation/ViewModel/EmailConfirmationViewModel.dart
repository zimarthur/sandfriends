import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Authentication/EmailConfirmation/Repository/EmailConfirmationRepoImp.dart';
import 'package:sandfriends/Utils/SharedPreferences.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../../Utils/PageStatus.dart';

class EmailConfirmationViewModel extends ChangeNotifier {
  final emailConfirmationRepo = EmailConfirmationRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  void confirmEmail(BuildContext context, String token) {
    emailConfirmationRepo.confirmEmail(context, token).then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        setAccessToken(context, responseBody['AccessToken']);
        Navigator.pushNamed(context, '/');
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () {
            Navigator.pushNamed(context, '/login_signup');
          },
          isHappy: response.responseStatus != NetworkResponseStatus.error,
        );
        pageStatus = PageStatus.ERROR;
      }
      notifyListeners();
    });
  }

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }
}
