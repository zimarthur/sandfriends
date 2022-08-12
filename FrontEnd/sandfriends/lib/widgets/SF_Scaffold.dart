import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/widgets/Modal/SF_Modal.dart';

import '../theme/app_theme.dart';

class SFScaffold extends StatefulWidget {
  final String titleText;
  final String goNamed;
  final Map<String, String>? goNamedParams;
  final Widget? rightWidget;
  final AppBarType appBarType;
  bool showModal;
  final Widget? modalWidget;
  final Widget child;
  final VoidCallback? onTapBackground;

  SFScaffold({
    required this.titleText,
    required this.goNamed,
    this.goNamedParams,
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: widget.appBarType == AppBarType.Primary
          ? AppTheme.colors.primaryBlue
          : AppTheme.colors.secondaryBack,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            width: width * 0.2,
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                if (widget.goNamedParams == null) {
                                  context.goNamed(widget.goNamed);
                                } else {
                                  context.goNamed(widget.goNamed,
                                      params: widget.goNamedParams!);
                                }
                              },
                              child: SvgPicture.asset(
                                r'assets\icon\arrow_left.svg',
                                height: 8.7,
                                width: 13.2,
                                color: widget.appBarType == AppBarType.Primary
                                    ? AppTheme.colors.secondaryBack
                                    : AppTheme.colors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          widget.titleText,
                          style: TextStyle(
                            color: widget.appBarType == AppBarType.Primary
                                ? AppTheme.colors.secondaryBack
                                : AppTheme.colors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        widget.rightWidget == null
                            ? Expanded(
                                child: Container(),
                              )
                            : Expanded(
                                child: Container(
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
    );
  }
}
