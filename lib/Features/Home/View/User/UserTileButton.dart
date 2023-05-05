import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/Constants.dart';

class UserTileButton extends StatefulWidget {
  String title;
  String iconPath;
  VoidCallback onTap;
  UserTileButton({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

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
              padding: EdgeInsets.only(left: 12),
              child: Text(
                widget.title,
                style: TextStyle(
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
