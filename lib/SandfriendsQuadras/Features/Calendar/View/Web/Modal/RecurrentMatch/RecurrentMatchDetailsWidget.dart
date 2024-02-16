import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppRecurrentMatch.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:sandfriends_web/SharedComponents/View/SFAvatar.dart';
import 'package:sandfriends_web/SharedComponents/View/SFDivider.dart';
import 'package:sandfriends_web/SharedComponents/View/SFTextfield.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Utils/SFDateTime.dart';
import '../../../../../../Common/Components/SFButton.dart';
import '../../../../../Menu/ViewModel/MenuProvider.dart';
import 'package:intl/intl.dart';

import '../Match/MatchDetailsWidgetRow.dart';

class RecurrentMatchDetailsWidget extends StatelessWidget {
  VoidCallback onReturn;
  VoidCallback onCancel;
  AppRecurrentMatch recurrentMatch;

  RecurrentMatchDetailsWidget({
    required this.onReturn,
    required this.onCancel,
    required this.recurrentMatch,
  });

  @override
  Widget build(BuildContext context) {
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
                        "Mensalista",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: textBlue),
                      ),
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
                          image: recurrentMatch.creatorPhoto,
                          isPlayerAvatar: true,
                          playerFirstName: recurrentMatch.creatorFirstName,
                          playerLastName: recurrentMatch.creatorLastName,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          recurrentMatch.creatorName,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  MatchDetailsWidgetRow(
                    title: "Dia",
                    value: weekdayRecurrent[recurrentMatch.weekday],
                  ),
                  MatchDetailsWidgetRow(
                      title: "Horário",
                      value:
                          "${recurrentMatch.startingHour.hourString} - ${recurrentMatch.endingHour.hourString}"),
                  MatchDetailsWidgetRow(
                      title: "Esporte",
                      value: recurrentMatch.sport!.description),
                  MatchDetailsWidgetRow(
                      title: "Partidas jogadas",
                      value: recurrentMatch.matchCounter.toString()),
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
                              color: greenBg,
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                            ),
                            child: Text(
                              "Pago",
                              style: TextStyle(color: greenText),
                            ),
                          ),
                        ],
                      )),
                  MatchDetailsWidgetRow(
                    title: "Preço",
                    value:
                        "R\$${recurrentMatch.currentMonthPrice},00 (${recurrentMatch.nextRecurrentMatches.length})",
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
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Cancelar mensalista",
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
