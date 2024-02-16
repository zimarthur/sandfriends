import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Common/Components/SFButton.dart';
import '../../../../Common/Utils/Constants.dart';

class DeleteAccountConfirmationModal extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback onReturn;
  const DeleteAccountConfirmationModal({
    Key? key,
    required this.onDelete,
    required this.onReturn,
  }) : super(key: key);

  @override
  State<DeleteAccountConfirmationModal> createState() =>
      _DeleteAccountConfirmationModalState();
}

class _DeleteAccountConfirmationModalState
    extends State<DeleteAccountConfirmationModal> {
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
            r"assets/icon/sad_face.svg",
            height: width * 0.25,
            width: width * 0.25,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          const Text(
            "Você quer mesmo excluir sua conta?",
            style: TextStyle(
              color: primaryBlue,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1.2,
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
              "Seus dados não serão reperados e suas partidas serão perdidas."),
          SizedBox(
            height: defaultPadding * 2,
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Voltar",
                  color: primaryBlue,
                  textPadding:
                      EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  isPrimary: false,
                  onTap: () => widget.onReturn(),
                ),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Excluir",
                  color: red,
                  textPadding:
                      EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  onTap: () => widget.onDelete(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
