import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Utils/Constants.dart';

class HomeLinkItem extends StatelessWidget {
  String iconPath;
  String title;
  VoidCallback onTap;
  HomeLinkItem({
    required this.onTap,
    required this.iconPath,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: 90,
        margin: EdgeInsets.only(
          left: defaultPadding,
        ),
        decoration: BoxDecoration(
          color: primaryBlue,
          border: Border.all(
            color: secondaryLightBlue,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 25,
              color: textWhite,
            ),
            SizedBox(
              height: defaultPadding / 4,
            ),
            Text(
              title,
              style: TextStyle(
                color: textWhite,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
