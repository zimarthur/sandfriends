import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardCard.dart';
import 'package:sandfriends/SharedComponents/View/PixCodeClipboard.dart';

import '../../../../SharedComponents/View/SFButton.dart';
import '../../../../SharedComponents/View/SFTextField.dart';
import '../../../../Utils/Constants.dart';

class PixModalResponse extends StatefulWidget {
  final String message;
  final String pixCode;
  final bool isRecurrent;
  final VoidCallback onReturn;
  const PixModalResponse({
    Key? key,
    required this.message,
    required this.pixCode,
    required this.isRecurrent,
    required this.onReturn,
  }) : super(key: key);

  @override
  State<PixModalResponse> createState() => _PixModalResponseState();
}

class _PixModalResponseState extends State<PixModalResponse> {
  bool hasCopiedPixToClipboard = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            r"assets/icon/happy_face.svg",
            height: width * 0.25,
            width: width * 0.25,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Text(
            "Seu horário foi reservado!\nEle será confirmado depois do pagamento do código Pix abaixo:",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w600,
            ),
            textScaleFactor: 1.1,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            hasCopiedPixToClipboard ? "copiado!" : "toque para copiar",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDarkGrey,
            ),
            textScaleFactor: 0.9,
          ),
          const SizedBox(
            height: defaultPadding / 4,
          ),
          PixCodeClipboard(
            pixCode: widget.pixCode,
            hasCopiedPixToClipboard: hasCopiedPixToClipboard,
            onCopied: () => setState(() {
              hasCopiedPixToClipboard = true;
            }),
            mainColor: widget.isRecurrent ? primaryLightBlue : primaryBlue,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            "(Sua reserva será cancelada se não for paga em 30 minutos)",
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: textDarkGrey,
            ),
            textScaleFactor: 0.9,
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          SFButton(
            buttonLabel: "Concluído",
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.02,
            ),
            onTap: () => widget.onReturn(),
          )
        ],
      ),
    );
  }
}
