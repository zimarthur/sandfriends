import 'package:flutter/material.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/Model/DrawerItem.dart';
import '../../../../../../Common/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../ViewModel/MenuProviderQuadras.dart';

class SFDrawerPopup extends StatefulWidget {
  bool showIcon;
  MenuProviderQuadras menuProvider;
  SFDrawerPopup({
    super.key,
    required this.showIcon,
    required this.menuProvider,
  });

  @override
  State<SFDrawerPopup> createState() => _SFDrawerPopupState();
}

class _SFDrawerPopupState extends State<SFDrawerPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      icon: widget.showIcon
          ? SvgPicture.asset(
              r'assets/icon/three_dots.svg',
              fit: BoxFit.scaleDown,
              color: secondaryPaper,
            )
          : Container(),
      tooltip: "",
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        for (var drawerItem in widget.menuProvider.secondaryDrawer)
          PopupMenuItem(
            value: drawerItem,
            child: Row(
              children: [
                SvgPicture.asset(
                  drawerItem.icon,
                  color: drawerItem.color ?? textDarkGrey,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  drawerItem.title,
                  style: TextStyle(
                    color: drawerItem.color ?? textDarkGrey,
                  ),
                ),
              ],
            ),
          ),
      ],
      onSelected: (value) {
        widget.menuProvider
            .onTabClick((value as DrawerItem).drawerPage, context);
      },
    );
  }
}
