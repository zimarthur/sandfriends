import 'package:flutter/material.dart';

import '../../SharedComponents/View/SFModalMessage.dart';
import '../../Utils/PageStatus.dart';
import '../Model/HomeTabsEnum.dart';
import '../View/Feed/FeedWidget.dart';
import '../View/SportSelector/SportSelectorWidget.dart';
import '../View/User/UserWidget.dart';

class HomeViewModel extends ChangeNotifier {
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

  void initHomeScreen(HomeTabs initialTab) {
    currentTab = initialTab;
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
}
