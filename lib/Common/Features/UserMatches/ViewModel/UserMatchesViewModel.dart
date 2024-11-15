import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../Model/AppMatch/AppMatchUser.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../Components/Modal/SFModalMessage.dart';
import '../../../Providers/Environment/EnvironmentProvider.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/UserMatchesRepo.dart';

class UserMatchesViewModel extends ChangeNotifier {
  final userMatchesRepo = UserMatchesRepo();

  void initUserMatchesViewModel(BuildContext context) {
    if (Provider.of<UserProvider>(context, listen: false).user == null) {
      Navigator.pushNamed(context, '/');
    }
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    userMatchesRepo
        .getUserMatches(
      context,
      Provider.of<EnvironmentProvider>(context, listen: false).accessToken!,
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
              Provider.of<CategoriesProvider>(context, listen: false).ranks,
              Provider.of<CategoriesProvider>(context, listen: false).genders,
            ),
          );
        }
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            buttonText: "Voltar",
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
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
          ),
        );
      }
    });
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
