import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/UserMatchesRepoImp.dart';

class UserMatchesViewModel extends ChangeNotifier {
  final userMatchesRepo = UserMatchesRepoImp();

  PageStatus pageStatus = PageStatus.LOADING;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget modalForm = Container();

  String titleText = "Minhas Partidas";

  void initUserMatchesViewModel(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    userMatchesRepo
        .getUserMatches(
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
            AppMatch.fromJson(
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
          message: response.userMessage!,
          onTap: () {
            initUserMatchesViewModel(context);
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

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }

  goToMatchScreen(BuildContext context, String matchUrl) {}
}
