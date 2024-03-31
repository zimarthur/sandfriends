import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';

import '../../../../Common/Enum/EnumClassFormat.dart';
import '../../../../Common/Utils/Constants.dart';

class ClassFrequencyPopUp extends StatefulWidget {
  EnumClassFrequency? currentClassFrequency;
  Function(EnumClassFrequency) onSelectedFrequency;
  bool enabled;
  ClassFrequencyPopUp({
    required this.currentClassFrequency,
    required this.onSelectedFrequency,
    required this.enabled,
    super.key,
  });

  @override
  State<ClassFrequencyPopUp> createState() => _ClassFrequencyPopUpState();
}

class _ClassFrequencyPopUpState extends State<ClassFrequencyPopUp> {
  List<EnumClassFrequency> frequencies = [
    EnumClassFrequency.None,
    EnumClassFrequency.OnceWeek,
    EnumClassFrequency.TwiceWeek,
  ];
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enabled: widget.enabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      surfaceTintColor: secondaryPaper,
      onSelected: (frequency) => widget.onSelectedFrequency(frequency),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        for (var frequency in frequencies)
          PopupMenuItem(
            value: frequency,
            child: Row(
              children: [
                SvgPicture.asset(
                  r"assets/icon/clock.svg",
                  height: 20,
                  color: primaryBlue,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  frequency.title,
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: secondaryPaper,
          border:
              Border.all(color: widget.enabled ? primaryBlue : textDarkGrey),
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
        ),
        padding: EdgeInsets.all(
          defaultPadding,
        ),
        child: widget.currentClassFrequency != null
            ? Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/clock.svg",
                    color: widget.enabled ? primaryBlue : textDarkGrey,
                    height: 20,
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    widget.currentClassFrequency!.title,
                    style: TextStyle(
                      color: widget.enabled ? primaryBlue : textDarkGrey,
                    ),
                  )
                ],
              )
            : Container(),
      ),
    );
  }
}
