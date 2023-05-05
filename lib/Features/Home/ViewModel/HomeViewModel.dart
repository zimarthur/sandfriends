import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Home/Repository/HomeRepoImp.dart';
import 'package:sandfriends/Features/Home/View/User/AppRatingModal.dart';
import 'package:sandfriends/SharedComponents/Model/AppNotification.dart';
import 'package:sandfriends/SharedComponents/Model/Reward.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../../Utils/PageStatus.dart';
import '../../../Utils/UrlLauncher.dart';
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
  Widget? widgetForm;

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
            Provider.of<DataProvider>(context, listen: false).user!.accessToken)
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

  final feedbackFormKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();

  void validateFeedback(BuildContext context) {
    if (feedbackFormKey.currentState?.validate() == true) {
      sendFeedback(context);
    }
  }

  void sendFeedback(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    homeRepo
        .sendFeedback(
      Provider.of<DataProvider>(context, listen: false).user!.accessToken,
      feedbackController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage.toString(),
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
      feedbackController.text = "";
    });
  }

  void contactSupport() {
    final url = Uri.parse("https://wa.me/+5551996712775");
    UrlLauncher(url);
  }

  void openAppRatingModal() {
    widgetForm = AppRatingModal(
      viewModel: this,
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void goToUSerDetail(BuildContext context) {
    Navigator.pushNamed(context, '/user_details');
  }

  void goToUserMatchScreen(BuildContext context) {
    Navigator.pushNamed(context, '/user_match_screen');
  }

  void goToNotificationScreen(BuildContext context) {
    Navigator.pushNamed(context, '/notification_screen');
  }

  void logOff(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }
}
