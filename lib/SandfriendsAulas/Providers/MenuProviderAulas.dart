import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/UserDetails/View/UserDetailsScreen.dart';
import 'package:sandfriends/Common/Providers/Drawer/DrawerProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/ClassesScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/View/HomeScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/View/StudentsScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeacherDetails/View/TeacherDetailsScreen.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/ViewModel/MenuProviderQuadras.dart';

import '../../Common/Providers/Drawer/EnumDeviceAvailable.dart';
import '../../Common/Providers/Drawer/EnumDrawerPage.dart';
import '../../SandfriendsQuadras/Features/Menu/Model/DrawerItem.dart';

class MenuProviderAulas extends DrawerProvider {
  void initMenuProviderAulas(BuildContext context, DrawerPage currentPage) {
    setDrawers(
      [
        DrawerItem(
          drawerPage: DrawerPage.Home,
          title: "Início",
          icon: r"assets/icon/home.svg",
          onTap: (context) => goToHome(context),
          deviceAvailable: DeviceAvailable.Mobile,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Profile,
          title: "Meu perfil",
          icon: r"assets/icon/user.svg",
          onTap: (context) => goToProfile(context),
          deviceAvailable: DeviceAvailable.Mobile,
        ),
        DrawerItem(
          drawerPage: DrawerPage.ClassPlans,
          title: "Planos e preços",
          icon: r"assets/icon/class_plans.svg",
          onTap: (context) => goToClassPlans(context),
          deviceAvailable: DeviceAvailable.Mobile,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Classes,
          title: "Aulas",
          icon: r"assets/icon/class.svg",
          onTap: (context) => goToClasses(context),
          deviceAvailable: DeviceAvailable.Mobile,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Teams,
          title: "Turmas",
          icon: r"assets/icon/team.svg",
          onTap: (context) => goToTeams(context),
          deviceAvailable: DeviceAvailable.Mobile,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Students,
          title: "Alunos",
          icon: r"assets/icon/user_group.svg",
          onTap: (context) => goToStudents(context),
          deviceAvailable: DeviceAvailable.Mobile,
        ),
      ],
    );
    onTabClick(currentPage, context, triggerTap: false);
  }

  @override
  void onTapReturn(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .setPageStatusOk();
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .clearOverlays();
    goToHome(context);
  }

  void goToHome(BuildContext context) {
    Navigator.of(context).pushNamed("/home");
  }

  void goToProfile(BuildContext context) {
    Navigator.of(context).pushNamed("/teacher_details");
  }

  void goToClassPlans(BuildContext context) {
    Navigator.of(context).pushNamed("/class_plans");
  }

  void goToClasses(BuildContext context) {
    Navigator.of(context).pushNamed("/classes");
  }

  void goToTeams(BuildContext context) {
    Navigator.of(context).pushNamed("/teams");
  }

  void goToStudents(BuildContext context) {
    Navigator.of(context).pushNamed("/students");
  }
}
