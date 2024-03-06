import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/PageStatus.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/ViewModel/MatchSearchViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/View/OnboardingModal.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/View/OnboardingScreen.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../Common/Managers/LocalStorage/LocalStorageManager.dart';
import '../../../../Common/Model/User/UserComplete.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Sandfriends/Features/Authentication/LoadLogin/Repository/LoadLoginRepo.dart';
import '../../../../Sandfriends/Features/Authentication/LoadLogin/ViewModel/LoadLoginViewModel.dart';
import '../../Authentication/ProfileOverlay/View/ProfileOverlay.dart';

class LandingPageViewModel extends MatchSearchViewModel {
  final loadLoginRepo = LoadLoginRepo();
  void initLandingPageViewModel(BuildContext context) async {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    String? accessToken = await LocalStorageManager().getAccessToken(context);

    loadLoginRepo.validateLogin(context, accessToken, false).then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<CategoriesProvider>(context, listen: false)
            .setCategoriesProvider(responseBody);

        final responseUser = responseBody['User'];
        //caso web, que não precisa estar logado para pesquisar quadras
        if (responseUser != null) {
          LocalStorageManager()
              .storeAccessToken(context, responseUser['AccessToken']);

          UserComplete loggedUser = UserComplete.fromJson(
            responseUser,
          );
          Provider.of<UserProvider>(context, listen: false).user = loggedUser;

          if (loggedUser.firstName == null) {
            closeModal();
            addOverlayWidget(
              OnboardingModal(
                parentViewModel: this,
              ),
            );

            return;
          }
        }
        Provider.of<CategoriesProvider>(context, listen: false).setSessionSport(
          sport: Provider.of<UserProvider>(context, listen: false)
              .user
              ?.preferenceSport,
        );
        initMatchSearchViewModel(
          context,
        );
      } else {}

      pageStatus = PageStatus.OK;
      notifyListeners();
    });
  }
}
