import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/MatchSearchFilter/View/FilterBasicWidget.dart';
import 'package:sandfriends/Features/MatchSearchFilter/View/FilterStoreWidget.dart';
import 'package:sandfriends/SharedComponents/Model/Sport.dart';
import 'package:sandfriends/SharedComponents/Model/TabItem.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

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

  bool get customFilterHasChanged => defaultCustomFilter != currentCustomFilter;
  bool isRecurrent = false;
  late SFTabItem selectedTab;
  late List<SFTabItem> tabs;

  bool hideOrderBy = false;

  void initViewModel(
    CustomFilter recDefaultCustomFilter,
    CustomFilter recCurrentCustomFilter,
    City? recCity,
    bool? recHideOrderBy,
    bool recIsRecurrent,
  ) {
    isRecurrent = recIsRecurrent;
    defaultCustomFilter = CustomFilter.copyFrom(recDefaultCustomFilter);
    currentCustomFilter = CustomFilter.copyFrom(recCurrentCustomFilter);
    cityFilter = recCity;

    hideOrderBy = recHideOrderBy ?? false;
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
    currentCustomFilter = CustomFilter.copyFrom(defaultCustomFilter);
    notifyListeners();
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context, currentCustomFilter);
  }

  void onChangeSport(Sport newSport) {
    currentCustomFilter.sport = newSport;
    notifyListeners();
  }

  void onNewOrderBy(BuildContext context, OrderBy newOrderBy) {
    if (newOrderBy == OrderBy.distance &&
        Provider.of<UserProvider>(context, listen: false).userLocation ==
            null) {
      modalMessage = SFModalMessage(
        message: Provider.of<UserProvider>(context, listen: false)
                .locationPermanentlyDenied
            ? "Você desabilitou a localização permanentemente. Apague os dados do app para habilitá-la novamente."
            : "Habilite o acesso a localização para ver as quadras mais perto de você!",
        onTap: () {
          Provider.of<UserProvider>(context, listen: false)
              .handlePositionPermission();
          pageStatus = PageStatus.OK;
          notifyListeners();
        },
        buttonText: "Ok!",
        isHappy: !Provider.of<UserProvider>(context, listen: false)
            .locationPermanentlyDenied,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
      return;
    }
    currentCustomFilter.orderBy = newOrderBy;
    notifyListeners();
  }
}
