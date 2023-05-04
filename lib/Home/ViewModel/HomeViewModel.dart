import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Home/Repository/HomeRepoImp.dart';
import 'package:sandfriends/SharedComponents/Model/AppNotification.dart';
import 'package:sandfriends/SharedComponents/Model/Reward.dart';

import '../../Remote/NetworkResponse.dart';
import '../../SharedComponents/Model/AppMatch.dart';
import '../../SharedComponents/View/SFModalMessage.dart';
import '../../SharedComponents/ViewModel/DataProvider.dart';
import '../../Utils/PageStatus.dart';
import '../Model/HomeTabsEnum.dart';
import '../View/Feed/FeedWidget.dart';
import '../View/SportSelector/SportSelectorWidget.dart';
import '../View/User/UserWidget.dart';

class HomeViewModel extends ChangeNotifier {
  final homeRepo = HomeRepoImp();

  PageStatus pageStatus = PageStatus.LOADING;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  Widget get displayWidget {
    switch (currentTab) {
      case HomeTabs.Feed:
        return FeedWidget(
          viewModel: this,
        );
      case HomeTabs.User:
        return UserWidget(
          viewModel: this,
        );

      case HomeTabs.SportSelector:
        return SportSelectorWidget(
          viewModel: this,
        );
    }
  }

  HomeTabs currentTab = HomeTabs.User;

  void initHomeScreen(HomeTabs initialTab, BuildContext context) {
    currentTab = initialTab;
    getUserInfo(context);
    notifyListeners();
  }

  void changeTab(HomeTabs newTab) {
    currentTab = newTab;
    notifyListeners();
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  Future<void> getUserInfo(BuildContext context) async {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    homeRepo
        .getUserInfo(
            Provider.of<DataProvider>(context, listen: false).accessToken!)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        final responseMatchCounter = responseBody['MatchCounter'];
        final responseMatches = responseBody['UserMatches'];
        final openMatchesCounter = responseBody['OpenMatchesCounter'];
        final responseNotifications = responseBody['Notifications'];
        final responseRewards = responseBody['UserRewards'];

        Provider.of<DataProvider>(context, listen: false)
            .user!
            .matchCounterFromJson(responseMatchCounter);

        for (var match in responseMatches) {
          Provider.of<DataProvider>(context, listen: false).addMatch(
            AppMatch.fromJson(
              match,
            ),
          );
        }

        Provider.of<DataProvider>(context, listen: false).openMatchesCounter =
            openMatchesCounter;

        Provider.of<DataProvider>(context, listen: false).userReward =
            Reward.fromJson(responseRewards['Reward']);
        Provider.of<DataProvider>(context, listen: false)
            .userReward!
            .userRewardQuantity = responseRewards['UserRewardQuantity'];

        for (var appNotification in responseNotifications) {
          Provider.of<DataProvider>(context, listen: false).addNotifications(
            AppNotification.fromJson(
              appNotification,
            ),
          );
        }
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () => getUserInfo(context),
          isHappy: false,
          buttonText: "Tentar novamente",
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void goToNotificationScreen(BuildContext context) {
    Navigator.pushNamed(context, '/notification_screen');
  }
}
