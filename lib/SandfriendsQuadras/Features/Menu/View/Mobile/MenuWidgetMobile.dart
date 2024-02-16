import 'package:flutter/material.dart';
import 'package:sandfriends_web/Utils/Responsive.dart';

import '../../../../Utils/Constants.dart';
import '../../ViewModel/MenuProvider.dart';
import '../../../Home/View/Mobile/HomeHeader.dart';

class MenuWidgetMobile extends StatefulWidget {
  MenuProvider viewModel;
  MenuWidgetMobile({required this.viewModel, super.key});

  @override
  State<MenuWidgetMobile> createState() => _MenuWidgetMobileState();
}

class _MenuWidgetMobileState extends State<MenuWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    return widget.viewModel.selectedDrawerItem.widgetMobile;
  }
}
