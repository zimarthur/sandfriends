import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/Model/User.dart';
import '../../../../SharedComponents/Model/Sport.dart';
import '../../../../SharedComponents/Model/Gender.dart';
import '../../../../SharedComponents/Model/Rank.dart';
import '../../../../SharedComponents/Model/SidePreference.dart';
import '../../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../../Utils/SharedPreferences.dart';
import '../Repository/LoadLoginRepoImp.dart';

class LoadLoginViewModel extends ChangeNotifier {
  final loadLoginRepo = LoadLoginRepoImp();

  Future<void> validateLogin(BuildContext context) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      goToLoginSignup(context);
    } else {
      loadLoginRepo.validateLogin(accessToken).then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          receiveLoginResponse(context, response.responseBody!);
        } else {
          goToLoginSignup(context);
        }
      });
    }
  }

  void redirectExternalLogin() {}

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }
}

void receiveLoginResponse(BuildContext context, String response) {
  Map<String, dynamic> responseBody = json.decode(
    response,
  );
  Provider.of<CategoriesProvider>(context, listen: false).clearAll();

  final responseSports = responseBody['Sports'];
  final responseGenders = responseBody['Genders'];
  final responseRanks = responseBody['Ranks'];
  final responseSidePreferences = responseBody['SidePreferences'];

  final responseUser = responseBody['User'];

  for (var sport in responseSports) {
    Provider.of<CategoriesProvider>(context, listen: false).sports.add(
          Sport.fromJson(
            sport,
          ),
        );
  }
  for (var gender in responseGenders) {
    Provider.of<CategoriesProvider>(context, listen: false).genders.add(
          Gender.fromJson(
            gender,
          ),
        );
  }
  for (var rank in responseRanks) {
    Provider.of<CategoriesProvider>(context, listen: false).ranks.add(
          Rank.fromJson(
            rank,
          ),
        );
  }
  for (var sidePreference in responseSidePreferences) {
    Provider.of<CategoriesProvider>(context, listen: false).sidePreferences.add(
          SidePreference.fromJson(
            sidePreference,
          ),
        );
  }

  setAccessToken(responseUser['AccessToken']);

  User loggedUser = User.fromJson(
    responseUser,
  );
  Provider.of<UserProvider>(context, listen: false).user = loggedUser;

  if (loggedUser.firstName == null) {
    Navigator.pushNamed(context, '/onboarding');
  } else {
    Navigator.pushNamed(context, '/home');
  }
}
