import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';

class ClassesScreenAulasViewModel extends MenuProviderAulas {
  void initClassesViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.Classes,
    );
    currentWeekday = getSFWeekday(DateTime.now().weekday);
    notifyListeners();
  }

  late int currentWeekday;

  void onUpdateWeekday(int newWeekday) {
    currentWeekday = newWeekday;
    notifyListeners();
  }
}
