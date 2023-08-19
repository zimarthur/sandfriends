import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Utils/Constants.dart';
import '../SFButton.dart';

class ConfirmationModal extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  bool isHappy;

  ConfirmationModal({
    Key? key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    required this.isHappy,
  }) : super(key: key);

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
            isHappy
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
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Não",
                  onTap: onCancel,
                  isPrimary: !isHappy,
                  textPadding:
                      EdgeInsets.symmetric(vertical: defaultPadding / 2),
                ),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Sim",
                  onTap: onConfirm,
                  isPrimary: isHappy,
                  textPadding:
                      EdgeInsets.symmetric(vertical: defaultPadding / 2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
