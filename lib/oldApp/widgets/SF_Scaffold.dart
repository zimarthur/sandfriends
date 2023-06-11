import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/oldApp/models/enums.dart';
import 'package:sandfriends/oldApp/widgets/Modal/SF_Modal.dart';

import '../theme/app_theme.dart';

class SFScaffold extends StatefulWidget {
  final String titleText;
  final Function()? onTapReturn;
  final Widget? rightWidget;
  final AppBarType appBarType;
  bool showModal;
  final Widget? modalWidget;
  final Widget child;
  final VoidCallback? onTapBackground;
  bool resizeToAvoidBottomInset = false;

  SFScaffold({
    required this.titleText,
    required this.onTapReturn,
    this.rightWidget,
    required this.appBarType,
    required this.showModal,
    this.modalWidget,
    this.onTapBackground,
    required this.child,
  });

  @override
  State<SFScaffold> createState() => _SFScaffoldState();
}

class _SFScaffoldState extends State<SFScaffold> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        widget.onTapReturn!();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        backgroundColor: widget.appBarType == AppBarType.Primary
            ? AppTheme.colors.primaryBlue
            : widget.appBarType == AppBarType.PrimaryLightBlue
                ? AppTheme.colors.primaryLightBlue
                : AppTheme.colors.secondaryBack,
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      //padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
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
                                      r'assets\icon\arrow_left.svg',
                                      width: width * 0.05,
                                      color: widget.appBarType ==
                                              AppBarType.Secondary
                                          ? AppTheme.colors.primaryBlue
                                          : AppTheme.colors.secondaryBack,
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
                                  ? AppTheme.colors.primaryBlue
                                  : AppTheme.colors.secondaryBack,
                              fontWeight: FontWeight.w500,
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
                    ),
                    Expanded(child: widget.child)
                  ],
                ),
              ),
              widget.showModal
                  ? SFModal(
                      child: widget.modalWidget!,
                      onTapBackground: widget.onTapBackground!,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
