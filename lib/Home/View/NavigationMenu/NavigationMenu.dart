import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../Model/HomeTabsEnum.dart';

class NavigationMenu extends StatefulWidget {
  Function(HomeTabs) onChangeTab;
  HomeTabs selectedTab;
  NavigationMenu({
    required this.onChangeTab,
    required this.selectedTab,
  });

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  List<NavigationMenuItem> navigationMenuItems = [
    NavigationMenuItem(
      tab: HomeTabs.User,
      image: r"assets\icon\navigation\user_screen.svg",
      imageActive: r"assets\icon\navigation\user_screen_selected.svg",
    ),
    NavigationMenuItem(
      tab: HomeTabs.Feed,
      image: r"assets\icon\navigation\feed_screen.svg",
      imageActive: r"assets\icon\navigation\feed_screen_selected.svg",
    ),
    NavigationMenuItem(
      tab: HomeTabs.SportSelector,
      image: r"assets\icon\navigation\schedule_screen.svg",
      imageActive: r"assets\icon\navigation\schedule_screen_selected.svg",
    ),
  ];

  double iconSize = 36.0;
  double navigationMenuHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutConstraints) {
        double iconContainerWidth =
            layoutConstraints.maxWidth / navigationMenuItems.length;
        double tileLocation = (iconContainerWidth / 2 - iconSize / 2) +
            widget.selectedTab.index * iconContainerWidth;
        return Container(
          width: layoutConstraints.maxWidth,
          height: navigationMenuHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: primaryBlue,
                  ),
                  height: 4,
                  width: iconSize,
                  margin: EdgeInsets.only(
                      top: (navigationMenuHeight / 2) - (iconSize / 2) - 10),
                ),
                left: tileLocation,
                duration: const Duration(
                  milliseconds: 100,
                ),
              ),
              Row(
                children: [
                  for (var navigationMenuitem in navigationMenuItems)
                    Expanded(
                      child: InkWell(
                        onTap: () => widget.onChangeTab(navigationMenuitem.tab),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: (navigationMenuHeight / 2) - (iconSize / 2),
                          ),
                          child: SvgPicture.asset(
                            navigationMenuitem.tab == widget.selectedTab
                                ? navigationMenuitem.imageActive
                                : navigationMenuitem.image,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class NavigationMenuItem {
  NavigationMenuItem({
    required this.tab,
    required this.image,
    required this.imageActive,
  });

  final HomeTabs tab;
  final String image;
  final String imageActive;
}
