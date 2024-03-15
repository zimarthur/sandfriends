import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
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
import '../../../../Sandfriends/Features/Home/Repository/HomeRepo.dart';
import '../../Authentication/ProfileOverlay/View/ProfileOverlay.dart';

class LandingPageViewModel extends MatchSearchViewModel {
  final loadLoginRepo = LoadLoginRepo();
  final homeRepo = HomeRepo();

  void initLandingPageViewModel(BuildContext context) async {
    if (Provider.of<UserProvider>(context, listen: false).user != null) {
      initMatchSearchViewModel(
        context,
      );
      return;
    }
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
          Provider.of<UserProvider>(context, listen: false)
              .setHasSearchUserData(false);
          LocalStorageManager()
              .storeAccessToken(context, responseUser['AccessToken']);

          UserComplete loggedUser = UserComplete.fromJson(
            responseUser,
          );
          Provider.of<UserProvider>(context, listen: false).user = loggedUser;

          if (loggedUser.firstName == null) {
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .removeLastOverlay();
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .addOverlayWidget(
              OnboardingModal(),
            );

            return;
          }
          getUserInfo(context);
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

      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  void getUserInfo(BuildContext context) {
    homeRepo
        .getUserInfo(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      null,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<UserProvider>(context, listen: false).clear();

        Provider.of<UserProvider>(context, listen: false)
            .receiveUserDataResponse(context, response.responseBody!);

        //canTapBackground = true;
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      }
      Provider.of<UserProvider>(context, listen: false)
          .setHasSearchUserData(true);
    });
  }

  void onTapLogin(BuildContext context) {
    {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addOverlayWidget(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ProfileOverlay(
            mustCloseWhenDone: true,
            close: () =>
                Provider.of<StandardScreenViewModel>(context, listen: false)
                    .clearOverlays(),
          ),
        ),
      );
    }
  }

  void onTapLoginDrawer(BuildContext context) {
    Scaffold.of(context).closeEndDrawer();
    onTapLogin(context);
  }

  void onTapProfile(BuildContext context) {
    Scaffold.of(context).closeEndDrawer();
    Navigator.pushNamed(context, '/jogador');
  }

  void onTapMatches(BuildContext context) {
    Scaffold.of(context).closeEndDrawer();
    Navigator.pushNamed(context, '/partidas');
  }
}
