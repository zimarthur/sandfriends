import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Common/Utils/Constants.dart';

class SFStandardHeader extends StatelessWidget {
  String? title;
  Widget? leftWidget;
  Widget? rightWidget;
  Widget? widget;
  bool isPrimaryBlue;

  SFStandardHeader({
    this.title,
    this.leftWidget,
    this.rightWidget,
    this.widget,
    this.isPrimaryBlue = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBlue,
      child: SafeArea(
        child: Container(
          height: 60,
          color: isPrimaryBlue ? primaryBlue : secondaryBack,
          child: widget != null
              ? Row(
                  children: [
                    Expanded(child: widget!),
                    InkWell(
                      onTap: () => Scaffold.of(context).openEndDrawer(),
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: SvgPicture.asset(
                          r"assets/icon/menu_burger.svg",
                          color: isPrimaryBlue ? textWhite : textBlue,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(children: [
                  Expanded(child: leftWidget ?? Container()),
                  Text(
                    title ?? "",
                    style: TextStyle(
                      color: isPrimaryBlue ? textWhite : primaryBlue,
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: rightWidget ?? Container(),
                      ),
                      InkWell(
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: SvgPicture.asset(
                            r"assets/icon/menu_burger.svg",
                            color: isPrimaryBlue ? textWhite : textBlue,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  )),
                ]),
        ),
      ),
    );
  }
}
