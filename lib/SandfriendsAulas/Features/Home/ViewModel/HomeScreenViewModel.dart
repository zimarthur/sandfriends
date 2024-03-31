import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';

class HomeScreenAulasViewModel extends MenuProviderAulas {
  void initHomeScreenViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.Home,
    );
    Provider.of<TeacherProvider>(context, listen: false)
        .getTeacherInfo(context);
  }
}
