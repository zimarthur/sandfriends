import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../Common/Components/SFButton.dart';
import '../../../../../../../Common/Components/SFTextField.dart';
import '../../../../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchStore.dart';
import '../../../../../../../Common/Utils/Constants.dart';
import '../../../../../Menu/ViewModel/MenuProvider.dart';

class RecurrentMatchCancelWidget extends StatelessWidget {
  VoidCallback onReturn;
  VoidCallback onCancel;
  AppRecurrentMatchStore recurrentMatch;
  TextEditingController controller;

  RecurrentMatchCancelWidget({
    required this.onReturn,
    required this.onCancel,
    required this.recurrentMatch,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return Container(
      width: 500,
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
            "Deseja mesmo cancelar o mensalista de ${recurrentMatch.creator.fullName}?",
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "*As partidas já agendadas não serão canceladas",
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
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
