import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/Model/Hour.dart';
import 'package:sandfriends/Sandfriends/Providers/RedirectProvider/RedirectProvider.dart';

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Model/User.dart';
import '../../../../../Common/Model/Sport.dart';
import '../../../../../Common/Model/Gender.dart';
import '../../../../../Common/Model/Rank.dart';
import '../../../../../Common/Model/SidePreference.dart';
import '../../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../Providers/UserProvider/UserProvider.dart';
import '../Repository/LoadLoginRepo.dart';

class LoadLoginViewModel extends ChangeNotifier {
  final loadLoginRepo = LoadLoginRepo();

  void validateLogin(BuildContext context) async {
    try {
      String? accessToken = await LocalStorageManager().getAccessToken(context);
      if (accessToken == null) {
        goToLoginSignup(context);
      } else {
        loadLoginRepo.validateLogin(context, accessToken).then((response) {
          if (response.responseStatus == NetworkResponseStatus.success) {
            receiveLoginResponse(context, response.responseBody!);
          } else {
            goToLoginSignup(context);
          }
        });
      }
    } catch (e) {
      goToLoginSignup(context);
    }
  }

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }

  void storeRedirectUri(BuildContext context, String redirectUri) {
    Provider.of<RedirectProvider>(context, listen: false).redirectUri =
        redirectUri;
  }
}

void receiveLoginResponse(BuildContext context, String response) {
  Map<String, dynamic> responseBody = json.decode(
    response,
  );
  Provider.of<CategoriesProvider>(context, listen: false).clearAll();

  final responseHours = responseBody['Hours'];
  final responseSports = responseBody['Sports'];
  final responseGenders = responseBody['Genders'];
  final responseRanks = responseBody['Ranks'];
  final responseSidePreferences = responseBody['SidePreferences'];
  final responseAvailableLocations = responseBody['States'];

  final responseUser = responseBody['User'];

  for (var hour in responseHours) {
    Provider.of<CategoriesProvider>(context, listen: false).hours.add(
          Hour.fromJson(
            hour,
          ),
        );
  }
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
  Provider.of<CategoriesProvider>(context, listen: false)
      .saveReceivedAvailableRegions(responseAvailableLocations);

  LocalStorageManager().storeAccessToken(context, responseUser['AccessToken']);

  User loggedUser = User.fromJson(
    responseUser,
  );

  User? userFromGoogle = Provider.of<UserProvider>(context, listen: false).user;

  Provider.of<UserProvider>(context, listen: false).user = loggedUser;
  if (loggedUser.firstName == null) {
    if (userFromGoogle != null) {
      loggedUser.firstName = userFromGoogle.firstName ?? "";
      loggedUser.lastName = userFromGoogle.lastName ?? "";
    }
    Navigator.pushNamed(context, '/onboarding');
  } else {
    Navigator.pushNamed(context, '/home');
  }
}
