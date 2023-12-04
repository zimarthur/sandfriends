import 'package:flutter/material.dart';
import 'package:sandfriends/Features/MatchSearchFilter/View/FilterBasicWidget.dart';
import 'package:sandfriends/Features/MatchSearchFilter/View/FilterStoreWidget.dart';
import 'package:sandfriends/SharedComponents/Model/Sport.dart';
import 'package:sandfriends/SharedComponents/Model/TabItem.dart';

import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Model/CustomFilter.dart';

class MatchSearchFilterViewModel extends ChangeNotifier {
  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;
  bool canTapBackground = true;

  City? cityFilter;
  late CustomFilter defaultCustomFilter;
  late CustomFilter currentCustomFilter;

  late SFTabItem selectedTab;
  late List<SFTabItem> tabs;

  void initViewModel(CustomFilter recDefaultCustomFilter,
      CustomFilter recCurrentCustomFilter, City? recCity) {
    defaultCustomFilter = recDefaultCustomFilter;
    currentCustomFilter = recCurrentCustomFilter;
    cityFilter = recCity;

    tabs = [
      SFTabItem(
        name: "Básico",
        onTap: (newTab) {
          selectedTab = newTab;
          notifyListeners();
        },
        displayWidget: FilterBasicWidget(),
      ),
      SFTabItem(
        name: "Quadras",
        onTap: (newTab) {
          selectedTab = newTab;
          notifyListeners();
        },
        displayWidget: FilterStoreWidget(),
      ),
    ];
    selectedTab = tabs.first;
    notifyListeners();
  }

  void clearFilter() {
    currentCustomFilter = defaultCustomFilter;
    notifyListeners();
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  void onChangeSport(Sport newSport) {
    currentCustomFilter.sport = newSport;
    notifyListeners();
  }

  void onNewOrderBy(OrderBy newOrderBy) {
    currentCustomFilter.orderBy = newOrderBy;
    notifyListeners();
  }
}
