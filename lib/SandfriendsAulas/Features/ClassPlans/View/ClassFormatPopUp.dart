import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Enum/EnumClassFormat.dart';
import '../../../../Common/Utils/Constants.dart';

class ClassFormatPopUp extends StatefulWidget {
  EnumClassFormat? currentFormat;
  Function(EnumClassFormat) onSelectedFormat;
  bool enabled;
  ClassFormatPopUp({
    required this.currentFormat,
    required this.onSelectedFormat,
    required this.enabled,
    super.key,
  });

  @override
  State<ClassFormatPopUp> createState() => _ClassFormatPopUpState();
}

class _ClassFormatPopUpState extends State<ClassFormatPopUp> {
  List<EnumClassFormat> formats = [
    EnumClassFormat.Individual,
    EnumClassFormat.Pair,
    EnumClassFormat.Group,
  ];
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enabled: widget.enabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      surfaceTintColor: secondaryPaper,
      onSelected: (format) => widget.onSelectedFormat(format),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        for (var format in formats)
          PopupMenuItem(
            value: format,
            child: Row(
              children: [
                SvgPicture.asset(
                  format.icon,
                  height: 20,
                  color: primaryBlue,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  format.title,
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
        child: widget.currentFormat != null
            ? Row(
                children: [
                  SvgPicture.asset(
                    widget.currentFormat!.icon,
                    color: widget.enabled ? primaryBlue : textDarkGrey,
                    height: 20,
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    widget.currentFormat!.titleShort,
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
