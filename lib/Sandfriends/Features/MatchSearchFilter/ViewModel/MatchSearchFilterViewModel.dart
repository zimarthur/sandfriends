import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/View/FilterBasicWidget.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/View/FilterStoreWidget.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/TabItem.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../Common/Model/City.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../Model/CustomFilter.dart';

class MatchSearchFilterViewModel extends ChangeNotifier {
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
        displayWidget: const FilterBasicWidget(),
      ),
      SFTabItem(
        name: "Quadras",
        onTap: (newTab) {
          selectedTab = newTab;
          notifyListeners();
        },
        displayWidget: const FilterStoreWidget(),
      ),
    ];
    selectedTab = tabs.first;
    notifyListeners();
  }

  void clearFilter() {
    currentCustomFilter = CustomFilter.copyFrom(defaultCustomFilter);
    notifyListeners();
  }

  void onChangeSport(Sport newSport) {
    currentCustomFilter.sport = newSport;
    notifyListeners();
  }

  void onNewOrderBy(BuildContext context, OrderBy newOrderBy) {
    if (newOrderBy == OrderBy.distance &&
        Provider.of<UserProvider>(context, listen: false).userLocation ==
            null) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: Provider.of<UserProvider>(context, listen: false)
                  .locationPermanentlyDenied
              ? "Você desabilitou a localização permanentemente. Apague os dados do app para habilitá-la novamente."
              : "Habilite o acesso a localização para ver as quadras mais perto de você!",
          onTap: () {
            Provider.of<UserProvider>(context, listen: false)
                .handlePositionPermission();
          },
          buttonText: "Ok!",
          isHappy: !Provider.of<UserProvider>(context, listen: false)
              .locationPermanentlyDenied,
        ),
      );

      return;
    }
    currentCustomFilter.orderBy = newOrderBy;
    notifyListeners();
  }
}
