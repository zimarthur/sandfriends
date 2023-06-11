import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/PageStatus.dart';
import 'package:sandfriends/oldApp/models/enums.dart';

import '../../../oldApp/theme/app_theme.dart';
import '../../../oldApp/widgets/SF_Button.dart';

class SFModalMessage extends StatefulWidget {
  final String message;
  final VoidCallback? onTap;
  String buttonText;
  bool isHappy;

  SFModalMessage({
    required this.message,
    required this.onTap,
    this.buttonText = "Concluído",
    required this.isHappy,
  });

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
        color: AppTheme.colors.secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.colors.primaryDarkBlue, width: 1),
        boxShadow: [
          BoxShadow(blurRadius: 1, color: AppTheme.colors.primaryDarkBlue)
        ],
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
                ? r"assets\icon\happy_face.svg"
                : r"assets\icon\sad_face.svg",
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
              style: TextStyle(
                color: AppTheme.colors.primaryBlue,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}