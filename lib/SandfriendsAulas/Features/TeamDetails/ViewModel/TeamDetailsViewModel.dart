import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/View/TeamDetailsAbout.dart';

import '../../../../Common/Model/TabItem.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';

class TeamDetailsViewModel extends StandardScreenViewModel {
  void initTeamDetailsViewModel(BuildContext context) {
    tabItems = [
      SFTabItem(
        name: "Sobre",
        displayWidget: TeamDetailsAbout(),
        onTap: (newTab) {
          setSelectedTab(newTab);
        },
      ),
      SFTabItem(
        name: "Próximas aulas",
        displayWidget: Container(),
        onTap: (newTab) {
          setSelectedTab(newTab);
        },
      ),
    ];
    setSelectedTab(tabItems.first);
    notifyListeners();
  }

  List<SFTabItem> tabItems = [];

  late SFTabItem _selectedTab;
  SFTabItem get selectedTab => _selectedTab;
  void setSelectedTab(SFTabItem newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }
}
