import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Utils/Constants.dart';
import '../SFButton.dart';

class SFModalMessage extends StatefulWidget {
  final String message;
  final VoidCallback? onTap;
  final String buttonText;
  final bool isHappy;
  final String? buttonIconPath;

  const SFModalMessage({
    Key? key,
    required this.message,
    required this.onTap,
    this.buttonText = "Concluído",
    required this.isHappy,
    this.buttonIconPath,
  }) : super(key: key);

  @override
  State<SFModalMessage> createState() => _SFModalMessageState();
}

class _SFModalMessageState extends State<SFModalMessage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.1, vertical: height * 0.03),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            widget.isHappy
                ? r"assets/icon/happy_face.svg"
                : r"assets/icon/sad_face.svg",
            height: width * 0.25,
            width: width * 0.25,
          ),
          Container(
            constraints: BoxConstraints(minHeight: height * 0.1),
            padding: EdgeInsets.symmetric(vertical: height * 0.03),
            alignment: Alignment.center,
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SizedBox(
              height: height * 0.05,
              child: SFButton(
                buttonLabel: widget.buttonText,
                onTap: widget.onTap,
                iconPath: widget.buttonIconPath ?? "",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
