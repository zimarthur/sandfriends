import 'package:flutter/material.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/MenuProviderQuadras.dart';
import 'DrawerWeb/SFDrawerWeb.dart';

class MenuWidgetWeb extends StatefulWidget {
  MenuProviderQuadras viewModel;
  MenuWidgetWeb({required this.viewModel, super.key});

  @override
  State<MenuWidgetWeb> createState() => _MenuWidgetWebState();
}

class _MenuWidgetWebState extends State<MenuWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SFDrawerWeb(
          viewModel: widget.viewModel,
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: secondaryBack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2 * defaultPadding,
                        vertical: defaultPadding),
                    child: widget.viewModel.selectedDrawerItem.widgetWeb,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
