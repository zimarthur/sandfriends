import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../../Common/Model/AppMatch/AppMatchUser.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../Repository/UserMatchesRepo.dart';

class UserMatchesViewModel extends StandardScreenViewModel {
  final userMatchesRepo = UserMatchesRepo();

  void initUserMatchesViewModel(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    userMatchesRepo
        .getUserMatches(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<UserProvider>(context, listen: false).clearMatches();
        for (var match in responseBody['UserMatches']) {
          Provider.of<UserProvider>(context, listen: false).addMatch(
            AppMatchUser.fromJson(
              match,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }

        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          buttonText: "Voltar",
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.expiredToken) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            } else {
              Navigator.pop(context);
            }
          },
          isHappy: false,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
