import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Authentication/EmailConfirmation/Repository/EmailConfirmationRepo.dart';

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../../Common/Utils/PageStatus.dart';

class EmailConfirmationViewModel extends StandardScreenViewModel {
  final emailConfirmationRepo = EmailConfirmationRepo();

  void confirmEmail(BuildContext context, String token) {
    emailConfirmationRepo.confirmEmail(context, token).then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        LocalStorageManager()
            .storeAccessToken(context, responseBody['AccessToken']);
        Navigator.pushNamed(context, '/');
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
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
