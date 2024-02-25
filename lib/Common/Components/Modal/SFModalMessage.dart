import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Common/Utils/Constants.dart';
import '../../../Common/Utils/Responsive.dart';
import '../SFButton.dart';

class SFModalMessage extends StatefulWidget {
  String title;
  String? description;
  final VoidCallback? onTap;
  final String buttonText;
  final bool isHappy;
  final String? buttonIconPath;
  bool hideButton;

  SFModalMessage({
    Key? key,
    required this.title,
    this.description,
    required this.onTap,
    this.buttonText = "Concluído",
    required this.isHappy,
    this.buttonIconPath,
    this.hideButton = false,
  }) : super(key: key);

  @override
  State<SFModalMessage> createState() => _SFModalMessageState();
}

class _SFModalMessageState extends State<SFModalMessage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(2 * defaultPadding),
      width: Responsive.isMobile(context)
          ? width * 0.8
          : width * 0.3 < 350
              ? 350
              : width * 0.3,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: primaryDarkBlue,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0, 0),
            color: primaryDarkBlue,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            widget.isHappy
                ? r"assets/icon/happy_face.svg"
                : r"assets/icon/sad_face.svg",
            height: Responsive.isMobile(context) ? 80 : 100,
          ),
          const SizedBox(
            height: 2 * defaultPadding,
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: widget.description == null ? textBlue : textBlack,
                fontSize: Responsive.isMobile(context) ? 16 : 24,
                fontWeight: widget.description == null
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
          if (widget.description != null)
            Column(
              children: [
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  widget.description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textDarkGrey,
                      fontSize: Responsive.isMobile(context) ? 12 : 14),
                ),
              ],
            ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          if (!widget.hideButton)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context)
                      ? 0
                      : width * 0.3 < 350
                          ? 35
                          : width * 0.03),
              child: SFButton(
                buttonLabel: widget.buttonText,
                onTap: widget.onTap,
                textPadding: EdgeInsets.symmetric(
                  vertical: defaultPadding / 2,
                ),
                iconPath: widget.buttonIconPath ?? "",
              ),
            )
        ],
      ),
    );
  }
}
