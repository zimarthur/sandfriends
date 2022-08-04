import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SandFriendsNavBar extends StatelessWidget {
  SandFriendsNavBar({
    Key? key,
    this.selectedIndex = 1,
    this.iconSize = 32,
    this.animationDuration = const Duration(milliseconds: 350),
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    required this.items,
    required this.onItemSelected,
  });

  final List<SandFriendsNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;
  final double iconSize;
  final Duration animationDuration;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: items.map(
          (item) {
            var index = items.indexOf(item);
            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: _ItemWidget(
                item: item,
                iconSize: iconSize,
                isSelected: index == selectedIndex,
                animationDuration: animationDuration,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final SandFriendsNavBarItem item;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    this.animationDuration = const Duration(milliseconds: 350),
    required this.iconSize,
    this.curve = Curves.ease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration myBoxDecoration;
    SvgPicture myImage;
    if (isSelected) {
      myBoxDecoration = BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: item.tabColor);
      myImage = item.imageActive;
    } else {
      myBoxDecoration = BoxDecoration(borderRadius: BorderRadius.circular(16));
      myImage = item.image;
    }
    return Semantics(
      container: true,
      selected: isSelected,
      child: Column(
        children: <Widget>[
          AnimatedContainer(
            curve: Curves.ease,
            duration: animationDuration,
            margin: const EdgeInsets.only(top: 8),
            width: 44,
            height: 4,
            decoration: myBoxDecoration,
          ),
          Container(
              margin: const EdgeInsets.only(top: 10),
              width: iconSize,
              height: iconSize,
              child: myImage),
        ],
      ),
    );
  }
}

class SandFriendsNavBarItem {
  SandFriendsNavBarItem({
    required this.image,
    required this.imageActive,
    required this.tabColor,
  });

  final SvgPicture image;
  final SvgPicture imageActive;
  final Color tabColor;
}
