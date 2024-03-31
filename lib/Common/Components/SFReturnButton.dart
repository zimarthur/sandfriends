import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Utils/Constants.dart';

class SFReturnButton extends StatelessWidget {
  Color color;
  bool isPrimary;
  VoidCallback? onTap;
  SFReturnButton({
    required this.color,
    required this.isPrimary,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap != null ? onTap!() : Navigator.pop(context),
      child: Container(
        margin: EdgeInsets.all(defaultPadding / 2),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary ? color : secondaryPaper,
        ),
        child: Center(
          child: SvgPicture.asset(
            r'assets/icon/arrow_left.svg',
            color: isPrimary ? secondaryPaper : color,
            height: 20,
          ),
        ),
      ),
    );
  }
}
