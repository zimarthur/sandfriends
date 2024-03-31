import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../Common/Model/AppBarType.dart';

class SFToolbar extends StatefulWidget {
  final String titleText;
  final AppBarType appBarType;
  final Function()? onTapReturn;
  final Widget? rightWidget;

  const SFToolbar({
    Key? key,
    required this.titleText,
    required this.onTapReturn,
    this.rightWidget,
    required this.appBarType,
  }) : super(key: key);

  @override
  State<SFToolbar> createState() => _SFToolbarState();
}

class _SFToolbarState extends State<SFToolbar> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: widget.appBarType == AppBarType.Primary
          ? primaryBlue
          : widget.appBarType == AppBarType.PrimaryLightBlue
              ? primaryLightBlue
              : secondaryPaper,
      height: toolbarHeight + topPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: widget.onTapReturn,
                  child: Container(
                    width: width * 0.15,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      r'assets/icon/arrow_left.svg',
                      width: width * 0.05,
                      color: widget.appBarType == AppBarType.Secondary
                          ? primaryBlue
                          : secondaryPaper,
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Text(
            widget.titleText,
            style: TextStyle(
              color: widget.appBarType == AppBarType.Secondary
                  ? primaryBlue
                  : secondaryPaper,
            ),
          ),
          widget.rightWidget == null
              ? Expanded(
                  child: Container(),
                )
              : Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    child: widget.rightWidget!,
                    alignment: Alignment.centerRight,
                  ),
                ),
        ],
      ),
    );
  }
}
