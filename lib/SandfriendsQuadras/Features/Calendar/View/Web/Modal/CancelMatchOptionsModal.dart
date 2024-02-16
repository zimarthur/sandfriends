import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Utils/Responsive.dart';
import '../../../../../../Common/Components/SFButton.dart';
import '../../../../../../SharedComponents/View/SFTextfield.dart';

class CancelMatchOptionsModal extends StatefulWidget {
  VoidCallback onReturn;

  CancelMatchOptionsModal({
    required this.onReturn,
  });

  @override
  State<CancelMatchOptionsModal> createState() =>
      _CancelMatchOptionsModalState();
}

class _CancelMatchOptionsModalState extends State<CancelMatchOptionsModal> {
  @override
  Widget build(BuildContext context) {
    double mobileWidth = MediaQuery.of(context).size.width;
    return Container(
      width: Responsive.isMobile(context) ? mobileWidth * 0.95 : 500,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Opções de cancelamento",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: red,
            ),
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Voltar",
                  buttonType: ButtonType.Secondary,
                  onTap: widget.onReturn,
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Cancelar partida",
                  buttonType: ButtonType.Delete,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
