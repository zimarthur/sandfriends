import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Utils/Constants.dart';

class UserTileButton extends StatefulWidget {
  String title;
  String iconPath;
  VoidCallback onTap;
  UserTileButton({Key? key, 
    required this.title,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  State<UserTileButton> createState() => _UserTileButtonState();
}

class _UserTileButtonState extends State<UserTileButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      highlightColor: primaryDarkBlue,
      child: Container(
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              widget.iconPath,
              height: 24,
              color: secondaryPaper,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: secondaryBack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
