import 'package:flutter/src/widgets/framework.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

class TeamsAulasScreenViewModel extends MenuProviderAulas {
  void initTeamsAulasViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.Teams,
    );
  }
}
