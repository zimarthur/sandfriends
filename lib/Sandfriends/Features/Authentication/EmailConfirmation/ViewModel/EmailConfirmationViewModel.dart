import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Authentication/EmailConfirmation/Repository/EmailConfirmationRepo.dart';

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';

class EmailConfirmationViewModel extends ChangeNotifier {
  final emailConfirmationRepo = EmailConfirmationRepo();

  void confirmEmail(BuildContext context, String token) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    emailConfirmationRepo
        .confirmEmail(
      context,
      token,
      Provider.of<EnvironmentProvider>(context, listen: false)
          .environment
          .isSandfriendsAulas,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        LocalStorageManager()
            .storeAccessToken(context, responseBody['AccessToken']);
        Navigator.pushNamed(context, '/');
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              goToLoginSignup(context);
            },
            isHappy: response.responseStatus != NetworkResponseStatus.error,
          ),
        );
      }
    });
  }

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(
        context,
        Provider.of<EnvironmentProvider>(context, listen: false)
                    .environment
                    .product ==
                Product.Sandfriends
            ? '/login_signup'
            : "/");
  }
}
