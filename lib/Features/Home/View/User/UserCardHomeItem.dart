import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Utils/Constants.dart';

class UserCardHomeItem extends StatelessWidget {
  String text;
  String iconPath;
  UserCardHomeItem({
    required this.text,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          color: secondaryPaper,
          width: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              text,
              style: TextStyle(
                color: textWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
