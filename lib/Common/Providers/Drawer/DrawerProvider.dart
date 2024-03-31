import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDeviceAvailable.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/Model/DrawerItem.dart';
import 'package:collection/collection.dart';

import '../../Managers/LocalStorage/LocalStorageManager.dart';

class DrawerProvider extends StandardScreenViewModel {
  List<DrawerItem> drawerItems = [];
  void setDrawers(List<DrawerItem> appDrawerItems) {
    drawerItems = appDrawerItems;
    notifyListeners();
  }

  bool _isEmployeeAdmin = false;
  bool get isEmployeeAdmin => _isEmployeeAdmin;
  void setIsEmployeeAdmin(bool newValue) {
    _isEmployeeAdmin = newValue;
    notifyListeners();
  }

  List<DrawerItem> get permissionsDrawerItems {
    if (isEmployeeAdmin) {
      return drawerItems;
    } else {
      return drawerItems
          .where((drawer) => drawer.requiresAdmin == false)
          .toList();
    }
  }

  List<DrawerItem> get mainDrawer {
    return permissionsDrawerItems.where((drawer) => drawer.mainDrawer).toList();
  }

  List<DrawerItem> get mobileDrawerItems => mainDrawer
      .where(
        (drawer) =>
            drawer.deviceAvailable == DeviceAvailable.Both ||
            drawer.deviceAvailable == DeviceAvailable.Mobile,
      )
      .toList();

  List<DrawerItem> get secondaryDrawer {
    return permissionsDrawerItems
        .where((drawer) => !drawer.mainDrawer)
        .toList();
  }

  late DrawerItem selectedDrawerItem;

  void _setSelectedDrawerItem(DrawerItem drawer) {
    selectedDrawerItem = drawer;
    notifyListeners();
  }

  void onTabClick(DrawerPage drawerPage, BuildContext context,
      {triggerTap = true}) {
    DrawerItem? foundDrawer = permissionsDrawerItems
        .firstWhereOrNull((drawer) => drawer.drawerPage == drawerPage);
    if (foundDrawer != null) {
      LocalStorageManager().storeLastPage(context, foundDrawer.title);
      _setSelectedDrawerItem(foundDrawer);
      if (foundDrawer.onTap != null && triggerTap) {
        foundDrawer.onTap!(context);
      }
      try {
        Scaffold.of(context).closeEndDrawer();
      } catch (e) {}
      notifyListeners();
    }
  }

  void quickLinkHome(BuildContext context) {
    onTabClick(
      DrawerPage.Home,
      context,
    );
  }

  void quickLinkBrand(BuildContext context) {
    onTabClick(
      DrawerPage.Profile,
      context,
    );
  }

  void quickLinkWorkingHours(BuildContext context) {
    onTabClick(
      DrawerPage.MyCourts,
      context,
    );
  }

  void quickLinkMyCourts(BuildContext context) {
    onTabClick(
      DrawerPage.MyCourts,
      context,
    );
  }

  bool get isOnHome => selectedDrawerItem.drawerPage == DrawerPage.Home;
}
