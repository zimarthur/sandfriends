import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/oldApp/models/enums.dart';

import '../../theme/app_theme.dart';
import '../SF_Button.dart';

class SFModalMessageCopy extends StatefulWidget {
  final GenericStatus modalStatus;
  final String message;
  final VoidCallback? onTap;

  const SFModalMessageCopy(
      {required this.modalStatus, required this.message, required this.onTap});

  @override
  State<SFModalMessageCopy> createState() => _SFModalMessageCopyState();
}

class _SFModalMessageCopyState extends State<SFModalMessageCopy> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.1, vertical: height * 0.03),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            widget.modalStatus == GenericStatus.Success
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
                buttonLabel: "Concluído",
                onTap: widget.onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
