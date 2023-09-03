import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Utils/Constants.dart';
import '../../Model/HomeTabsEnum.dart';

class NavigationMenu extends StatefulWidget {
  final Function(HomeTabs) onChangeTab;
  final HomeTabs selectedTab;
  const NavigationMenu({
    Key? key,
    required this.onChangeTab,
    required this.selectedTab,
  }) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  List<NavigationMenuItem> navigationMenuItems = [
    NavigationMenuItem(
      tab: HomeTabs.User,
      image: r"assets/icon/navigation/user_screen.svg",
      imageActive: r"assets/icon/navigation/user_screen_selected.svg",
    ),
    NavigationMenuItem(
      tab: HomeTabs.Feed,
      image: r"assets/icon/navigation/feed_screen.svg",
      imageActive: r"assets/icon/navigation/feed_screen_selected.svg",
    ),
    NavigationMenuItem(
      tab: HomeTabs.SportSelector,
      image: r"assets/icon/navigation/schedule_screen.svg",
      imageActive: r"assets/icon/navigation/schedule_screen_selected.svg",
    ),
  ];

  double iconSize = 24.0;
  double navigationMenuHeight = 65.0;

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
                  milliseconds: 200,
                ),
              ),
              SizedBox(
                height: layoutConstraints.maxHeight,
                child: Row(
                  children: [
                    for (var navigationMenuitem in navigationMenuItems)
                      Expanded(
                        child: SizedBox(
                          height: layoutConstraints.maxHeight,
                          child: InkWell(
                            onTap: () =>
                                widget.onChangeTab(navigationMenuitem.tab),
                            child: Center(
                              child: SvgPicture.asset(
                                navigationMenuitem.tab == widget.selectedTab
                                    ? navigationMenuitem.imageActive
                                    : navigationMenuitem.image,
                                height: iconSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
