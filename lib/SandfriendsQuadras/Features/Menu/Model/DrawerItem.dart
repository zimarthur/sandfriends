import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  String icon;
  Widget widgetWeb;
  Widget widgetMobile;
  bool mainDrawer;
  bool requiresAdmin;
  Color? color;
  bool logout;
  bool availableMobile;
  bool isNew;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.requiresAdmin,
    required this.mainDrawer,
    required this.widgetWeb,
    required this.widgetMobile,
    this.color,
    this.logout = false,
    this.availableMobile = false,
    this.isNew = false,
  });
}
