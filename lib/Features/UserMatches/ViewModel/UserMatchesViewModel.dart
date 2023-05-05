import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/UserMatches/Repository/UserMatchesRepoImp.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';

import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';

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
      Provider.of<DataProvider>(context, listen: false).user!.accessToken,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<DataProvider>(context, listen: false).clearMatches();
        for (var match in responseBody['Matches']) {
          Provider.of<DataProvider>(context, listen: false).addMatch(
            AppMatch.fromJson(
              match,
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
