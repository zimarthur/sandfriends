import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

class StudentsScreenAulasViewModel extends MenuProviderAulas {
  void initStudentsViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.Students,
    );
  }
}
