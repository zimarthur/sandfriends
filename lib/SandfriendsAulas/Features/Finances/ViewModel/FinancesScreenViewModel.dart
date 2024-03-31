import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

class FinancesScreenAulasViewModel extends MenuProviderAulas {
  void initFinancesViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.Finances,
    );
  }
}
