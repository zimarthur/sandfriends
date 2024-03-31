import 'package:flutter/src/widgets/framework.dart';
import 'package:sandfriends/Common/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';

import '../../../Providers/MenuProviderAulas.dart';

class TeacherDetailsViewModel extends MenuProviderAulas {
  void initTeacherDetailsViewModel(BuildContext context) {
    initMenuProviderAulas(context, DrawerPage.Profile);
  }
}
