import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:provider/provider.dart';
import '../../../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../../../Common/Components/SFButton.dart';
import '../../../../../../../Common/Components/SFDivider.dart';
import '../../../../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchStore.dart';
import '../../../../../../../Common/Utils/Constants.dart';
import '../../../../../Menu/ViewModel/MenuProvider.dart';
import 'package:intl/intl.dart';

import '../Match/MatchDetailsWidgetRow.dart';

class RecurrentMatchDetailsWidget extends StatelessWidget {
  VoidCallback onReturn;
  VoidCallback onCancel;
  AppRecurrentMatchStore recurrentMatch;

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
                        SFAvatarStore(
                          height: 50,
                          user: recurrentMatch.creator,
                          isPlayerAvatar: true,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          recurrentMatch.creator.fullName,
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
                          "${recurrentMatch.timeBegin.hourString} - ${recurrentMatch.timeEnd.hourString}"),
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
                    buttonLabel: "Voltar", isPrimary: false, onTap: onReturn),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Cancelar mensalista",
                  color: red,
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
