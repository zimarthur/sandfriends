import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:sandfriends_web/SharedComponents/Model/SelectedPayment.dart';
import 'package:sandfriends_web/SharedComponents/View/SFAvatar.dart';
import 'package:sandfriends_web/SharedComponents/View/SFDivider.dart';
import 'package:sandfriends_web/SharedComponents/View/SFTextfield.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Utils/SFDateTime.dart';
import '../../../../../../Common/Components/SFButton.dart';
import '../../../../../Menu/ViewModel/MenuProvider.dart';
import 'package:intl/intl.dart';

import 'MatchDetailsWidgetRow.dart';

class MatchDetailsWidget extends StatelessWidget {
  VoidCallback onReturn;
  VoidCallback onCancel;
  AppMatch match;

  MatchDetailsWidget({
    required this.onReturn,
    required this.onCancel,
    required this.match,
  });
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = match.creatorNotes;
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return Container(
      height: height * 0.9,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Partida agendada",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: textBlue),
                      ),
                      if (isHourPast(
                        match.date,
                        match.startingHour,
                      ))
                        Expanded(
                            child: Text(
                          "Encerrada",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: textLightGrey,
                            fontSize: 18,
                          ),
                        ))
                    ],
                  ),
                  const SizedBox(
                    height: 2 * defaultPadding,
                  ),
                  MatchDetailsWidgetRow(
                    title: "Criador",
                    customValue: Row(
                      children: [
                        SFAvatar(
                          height: 50,
                          image: match.matchCreatorPhoto,
                          isPlayerAvatar: true,
                          playerFirstName: match.matchCreatorFirstName,
                          playerLastName: match.matchCreatorLastName,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          match.matchCreatorName,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  MatchDetailsWidgetRow(
                      title: "Dia",
                      value: DateFormat("dd/MM/yyyy").format(match.date)),
                  MatchDetailsWidgetRow(
                      title: "Horário",
                      value:
                          "${match.startingHour.hourString} - ${match.endingHour.hourString}"),
                  MatchDetailsWidgetRow(
                      title: "Esporte", value: match.sport!.description),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: SFDivider(),
                  ),
                  MatchDetailsWidgetRow(
                    title: "Recado de ${match.matchCreatorFirstName}",
                    customValue: SFTextField(
                      labelText: "",
                      pourpose: TextFieldPourpose.Multiline,
                      minLines: 4,
                      maxLines: 4,
                      controller: controller,
                      validator: (a) {
                        return null;
                      },
                      enable: false,
                    ),
                    fixedHeight: false,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: SFDivider(),
                  ),
                  MatchDetailsWidgetRow(
                      title: "Status",
                      customValue: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding / 4,
                                horizontal: defaultPadding / 2),
                            decoration: BoxDecoration(
                              color: match.selectedPayment ==
                                      SelectedPayment.PayInStore
                                  ? redBg
                                  : greenBg,
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                            ),
                            child: Text(
                              match.selectedPayment ==
                                      SelectedPayment.PayInStore
                                  ? "Pagar no local"
                                  : "Pago",
                              style: TextStyle(
                                color: match.selectedPayment ==
                                        SelectedPayment.PayInStore
                                    ? redText
                                    : greenText,
                              ),
                            ),
                          ),
                        ],
                      )),
                  MatchDetailsWidgetRow(
                    title: "Preço",
                    value: "R\$${match.cost},00",
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                    buttonLabel: "Voltar",
                    buttonType: ButtonType.Secondary,
                    onTap: onReturn),
              ),
              if (!isHourPast(
                match.date,
                match.startingHour,
              ))
                SizedBox(
                  width: defaultPadding,
                ),
              if (!isHourPast(
                match.date,
                match.startingHour,
              ))
                Expanded(
                  child: SFButton(
                    buttonLabel: "Cancelar partida",
                    buttonType: ButtonType.Delete,
                    onTap: onCancel,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
