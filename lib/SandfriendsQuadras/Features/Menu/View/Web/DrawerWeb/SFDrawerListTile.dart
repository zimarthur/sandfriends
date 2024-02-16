import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:sandfriends_web/Utils/Responsive.dart';

class SFDrawerListTile extends StatefulWidget {
  SFDrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.isSelected,
    required this.isHovered,
    required this.fullSize,
    required this.isNew,
  }) : super(key: key);

  final String title, svgSrc;
  bool isSelected, fullSize, isHovered, isNew;

  @override
  State<SFDrawerListTile> createState() => _SFDrawerListTileState();
}

class _SFDrawerListTileState extends State<SFDrawerListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isSelected
            ? primaryDarkBlue
            : widget.isHovered
                ? primaryLightBlue.withOpacity(0.5)
                : primaryBlue,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      padding: const EdgeInsets.all(defaultPadding),
      child: widget.fullSize
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  widget.svgSrc,
                  color: Colors.white,
                  height: 16,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                if (widget.isNew && Responsive.isMobile(context))
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2,
                    ),
                    decoration: BoxDecoration(
                      color: textWhite,
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadius,
                      ),
                    ),
                    child: Text(
                      "Novo!",
                      style: TextStyle(
                          color: textBlue, fontWeight: FontWeight.bold),
                    ),
                  )
              ],
            )
          : SvgPicture.asset(
              widget.svgSrc,
              color: Colors.white,
              height: 16,
            ),
    );
  }
}
