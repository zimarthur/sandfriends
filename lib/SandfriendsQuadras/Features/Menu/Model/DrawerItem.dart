import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDeviceAvailable.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';

class DrawerItem {
  DrawerPage drawerPage;
  String title;
  String icon;
  Widget? widgetWeb;
  Widget? widgetMobile;
  bool mainDrawer;
  bool requiresAdmin;
  Color? color;
  Function(BuildContext)? onTap;
  DeviceAvailable deviceAvailable;
  bool isNew;

  DrawerItem({
    required this.drawerPage,
    required this.title,
    required this.icon,
    this.requiresAdmin = false,
    this.mainDrawer = true,
    this.widgetWeb,
    this.widgetMobile,
    this.color,
    this.onTap,
    required this.deviceAvailable,
    this.isNew = false,
  });
}
