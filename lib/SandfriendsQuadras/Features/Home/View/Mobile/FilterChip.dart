import 'package:flutter/material.dart';

import '../../../../../Common/Utils/Constants.dart';

class SFFilterChip extends StatefulWidget {
  String title;
  bool isEnabled;
  VoidCallback onTap;
  SFFilterChip({
    required this.title,
    required this.isEnabled,
    required this.onTap,
    super.key,
  });

  @override
  State<SFFilterChip> createState() => _SFFilterChipState();
}

class _SFFilterChipState extends State<SFFilterChip> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
        margin: EdgeInsets.only(
          right: defaultPadding / 4,
        ),
        decoration: BoxDecoration(
          color: widget.isEnabled ? primaryBlue : textWhite,
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
          border: Border.all(
            color: widget.isEnabled ? primaryBlue : textDarkGrey,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        child: Text(
          widget.title,
          style: TextStyle(color: widget.isEnabled ? textWhite : textDarkGrey),
        ),
      ),
    );
  }
}
