import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/View/SFToolbar.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../Utils/PageStatus.dart';
import '../Model/AppBarType.dart';
import 'SFLoading.dart';
import 'Modal/SFModalMessage.dart';

class SFStandardScreen extends StatefulWidget {
  final String? titleText;
  Widget child;
  final AppBarType? appBarType;
  PageStatus pageStatus;
  final Function()? onTapReturn;
  Widget? modalFormWidget;
  SFModalMessage? messageModalWidget;
  final Widget? rightWidget;
  final VoidCallback? onTapBackground;
  bool resizeToAvoidBottomInset = false;
  bool enableToolbar;

  SFStandardScreen({
    Key? key,
    this.titleText,
    this.onTapReturn,
    required this.pageStatus,
    required this.child,
    this.rightWidget,
    this.appBarType,
    this.modalFormWidget,
    this.messageModalWidget,
    this.onTapBackground,
    this.enableToolbar = true,
  }) : super(key: key);

  @override
  State<SFStandardScreen> createState() => _SFStandardScreenState();
}

class _SFStandardScreenState extends State<SFStandardScreen> {
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
            ? primaryBlue
            : widget.appBarType == AppBarType.PrimaryLightBlue
                ? primaryLightBlue
                : secondaryBack,
        body: SafeArea(
          top: widget.enableToolbar,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      widget.enableToolbar
                          ? SFToolbar(
                              titleText: widget.titleText!,
                              onTapReturn: widget.onTapReturn,
                              appBarType: widget.appBarType!,
                              rightWidget: widget.rightWidget,
                            )
                          : Container(),
                      Expanded(child: widget.child)
                    ],
                  ),
                ),
              ),
              widget.pageStatus != PageStatus.OK
                  ? InkWell(
                      onTap: widget.onTapBackground,
                      child: Container(
                        color: primaryBlue.withOpacity(0.4),
                        height: height,
                        width: width,
                        child: Center(
                          child: widget.pageStatus == PageStatus.LOADING
                              ? const SFLoading()
                              : InkWell(
                                  onTap: () {},
                                  child: widget.pageStatus == PageStatus.FORM
                                      ? widget.modalFormWidget
                                      : widget.messageModalWidget,
                                ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
