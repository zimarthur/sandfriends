import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../Components/SFLoading.dart';
import '../Components/SFToolbar.dart';
import '../Providers/Environment/EnvironmentProvider.dart';
import '../Utils/PageStatus.dart';
import '../Model/AppBarType.dart';
import '../Utils/Responsive.dart';

class StandardScreen extends StatefulWidget {
  final String? titleText;
  final Widget child;
  final Widget? childWeb;
  final AppBarType? appBarType;
  final Color? background;
  final Widget? rightWidget;
  final bool resizeToAvoidBottomInset = false;
  final bool enableToolbar;
  Widget? drawer;
  Key? scaffoldKey;
  VoidCallback? customOnTapReturn;

  StandardScreen({
    Key? key,
    this.titleText,
    required this.child,
    this.childWeb,
    this.rightWidget,
    this.appBarType = AppBarType.Primary,
    this.enableToolbar = true,
    this.background,
    this.drawer,
    this.scaffoldKey,
    this.customOnTapReturn,
  }) : super(key: key);

  @override
  State<StandardScreen> createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {
  double horizontalDragStart = 0.0;
  late VoidCallback onTapReturn;

  @override
  void initState() {
    onTapReturn = widget.customOnTapReturn ??
        () => Provider.of<StandardScreenViewModel>(context, listen: false)
            .onTapReturn(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: Provider.of<EnvironmentProvider>(context, listen: false)
              .environment
              .isIos
          ? null
          : () async {
              onTapReturn();
              return false;
            },
      child: Scaffold(
        endDrawer: widget.drawer,
        key: widget.scaffoldKey,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        backgroundColor: widget.background ??
            (widget.appBarType == AppBarType.Primary
                ? primaryBlue
                : widget.appBarType == AppBarType.PrimaryLightBlue
                    ? primaryLightBlue
                    : secondaryBack),
        body: SafeArea(
          top: widget.enableToolbar,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                onHorizontalDragStart: (details) {
                  horizontalDragStart = details.globalPosition.dx;
                },
                onHorizontalDragUpdate: (details) {
                  if ((horizontalDragStart < width * 0.15) &&
                      ((details.globalPosition.dx - horizontalDragStart) >
                          width * 0.1) &&
                      Provider.of<EnvironmentProvider>(context, listen: false)
                          .environment
                          .isIos) {
                    onTapReturn();
                    horizontalDragStart = 0.0;
                  }
                },
                child: Container(
                  decoration:
                      Provider.of<EnvironmentProvider>(context, listen: false)
                                  .environment
                                  .isWeb &&
                              !Responsive.isMobile(context)
                          ? const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [primaryBlue, primaryLightBlue],
                              ),
                            )
                          : null,
                  width: width,
                  height: height,
                  child: Responsive.isMobile(context)
                      ? Column(
                          children: [
                            widget.enableToolbar
                                ? SFToolbar(
                                    titleText: widget.titleText!,
                                    onTapReturn: () => onTapReturn(),
                                    appBarType: widget.appBarType!,
                                    rightWidget: widget.rightWidget,
                                  )
                                : Container(),
                            Expanded(child: widget.child)
                          ],
                        )
                      : Center(
                          child: widget.childWeb,
                        ),
                ),
              ),
              for (var overlay
                  in Provider.of<StandardScreenViewModel>(context).overlays)
                Visibility(
                  maintainState: true,
                  visible: (Provider.of<StandardScreenViewModel>(context)
                                  .overlays
                                  .indexOf(overlay) +
                              1) ==
                          Provider.of<StandardScreenViewModel>(context)
                              .overlays
                              .length ||
                      overlay.showOnlyIfLast == false,
                  child: InkWell(
                    onTap: () {
                      if (Provider.of<StandardScreenViewModel>(context,
                              listen: false)
                          .canTapBackground) {
                        Provider.of<StandardScreenViewModel>(context,
                                listen: false)
                            .closeModal();
                      }
                    },
                    child: Container(
                        color: primaryBlue.withOpacity(0.4),
                        height: height,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(onTap: () {}, child: overlay.widget),
                            SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            )
                          ],
                        )),
                  ),
                ),
              if (Provider.of<StandardScreenViewModel>(context).isLoading)
                Container(
                  color: primaryBlue.withOpacity(0.4),
                  height: height,
                  width: width,
                  child: SFLoading(),
                ),
              if (Provider.of<EnvironmentProvider>(context, listen: false)
                      .environment
                      .flavor !=
                  Flavor.Prod)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "${Provider.of<EnvironmentProvider>(context).environment.flavor.flavorString} 15",
                      style: const TextStyle(
                          fontSize: 12, backgroundColor: textWhite, color: red),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
