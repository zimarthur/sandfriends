import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Utils/Constants.dart';

class CourtContactItem extends StatefulWidget {
  String icon;
  String text;
  VoidCallback onTap;
  bool expandedText;
  CourtContactItem({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.expandedText,
    super.key,
  });

  @override
  State<CourtContactItem> createState() => _CourtContactItemState();
}

class _CourtContactItemState extends State<CourtContactItem> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    Color color = isHovered ? primaryDarkBlue : textDarkGrey;
    return MouseRegion(
      onEnter: (pointer) => setState(() {
        isHovered = true;
      }),
      onExit: (pointer) => setState(() {
        isHovered = false;
      }),
      child: InkWell(
        onTap: () => widget.onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.icon,
              color: color,
              width: 20,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            widget.expandedText
                ? Expanded(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: color,
                        fontWeight:
                            isHovered ? FontWeight.bold : FontWeight.normal,
                      ),
                      maxLines: 1,
                    ),
                  )
                : Text(
                    widget.text,
                    style: TextStyle(
                      color: color,
                      fontWeight:
                          isHovered ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                  ),
          ],
        ),
      ),
    );
  }
}
