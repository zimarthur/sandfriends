import 'package:flutter/material.dart';
import '../../ViewModel/MenuProviderQuadras.dart';
import '../../../Home/View/Mobile/HomeHeaderQuadras.dart';

class MenuWidgetMobile extends StatefulWidget {
  MenuProviderQuadras viewModel;
  MenuWidgetMobile({required this.viewModel, super.key});

  @override
  State<MenuWidgetMobile> createState() => _MenuWidgetMobileState();
}

class _MenuWidgetMobileState extends State<MenuWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    return widget.viewModel.selectedDrawerItem.widgetMobile ?? Container();
  }
}
