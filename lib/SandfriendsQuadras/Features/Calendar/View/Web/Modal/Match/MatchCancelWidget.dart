import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../Common/Components/SFButton.dart';
import '../../../../../../../Common/Components/SFTextField.dart';
import '../../../../../../../Common/Model/AppMatch/AppMatchStore.dart';
import '../../../../../../../Common/Utils/Constants.dart';
import '../../../../../../../Common/Utils/Responsive.dart';
import '../../../../../Menu/ViewModel/MenuProviderQuadras.dart';
import '../../../../ViewModel/CalendarViewModel.dart';

class MatchCancelWidget extends StatelessWidget {
  VoidCallback onReturn;
  VoidCallback onCancel;
  AppMatchStore match;
  TextEditingController controller;

  MatchCancelWidget({
    required this.onReturn,
    required this.onCancel,
    required this.match,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double width =
        Provider.of<MenuProviderQuadras>(context).getScreenWidth(context);
    double height =
        Provider.of<MenuProviderQuadras>(context).getScreenHeight(context);
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Deseja mesmo cancelar a partida de ${match.matchCreator.fullName}?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textBlue,
            ),
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          SFTextField(
            labelText: "",
            pourpose: TextFieldPourpose.Multiline,
            minLines: 4,
            maxLines: 4,
            hintText: "Escreva o motivo do cancelamento",
            controller: controller,
            validator: (a) {
              return null;
            },
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Voltar",
                  isPrimary: false,
                  onTap: onReturn,
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Cancelar partida",
                  color: red,
                  onTap: onCancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
