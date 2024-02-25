import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../../../Common/Components/SFButton.dart';
import '../../../../../../../Common/Components/SFDivider.dart';
import '../../../../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchStore.dart';
import '../../../../../../../Common/Model/Court.dart';
import '../../../../../../../Common/Utils/Constants.dart';
import '../../../../../../../Common/Utils/SFDateTime.dart';
import '../../../../../Menu/ViewModel/DataProvider.dart';
import '../../../../../Menu/ViewModel/MenuProvider.dart';
import '../../../../Model/DayMatch.dart';
import '../../../../ViewModel/CalendarViewModel.dart';
import '../Match/MatchDetailsWidgetRow.dart';

class RecurrentCourtsAvailabilityWidget extends StatelessWidget {
  CalendarViewModel viewModel;
  DateTime day;
  DayMatch dayMatch;

  RecurrentCourtsAvailabilityWidget({
    super.key,
    required this.viewModel,
    required this.day,
    required this.dayMatch,
  });

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return Container(
      height: height * 0.9,
      width: width * 0.5 < 500 ? 500 : width * 0.5,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Mensalistas do dia",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: textBlue),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                MatchDetailsWidgetRow(
                  title: "Dia",
                  value: getWeekdayTextFromDatetime(day),
                ),
                MatchDetailsWidgetRow(
                  title: "Horário",
                  value:
                      "${dayMatch.startingHour.hourString} - ${Provider.of<DataProvider>(context, listen: false).availableHours.firstWhere((hr) => hr.hour > dayMatch.startingHour.hour).hourString}",
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: SFDivider(),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: Provider.of<DataProvider>(context, listen: false)
                      .courts
                      .length,
                  itemBuilder: (context, index) {
                    AppRecurrentMatchStore? recurrentMatch;
                    Court court =
                        Provider.of<DataProvider>(context, listen: false)
                            .courts[index];
                    bool allowRecurrent = court.operationDays
                        .firstWhere((opDay) =>
                            opDay.weekday == getSFWeekday(day.weekday))
                        .allowReccurrent;
                    if (dayMatch.recurrentMatches!.any((recMatch) =>
                        recMatch.court.idStoreCourt == court.idStoreCourt)) {
                      recurrentMatch = dayMatch.recurrentMatches!.firstWhere(
                        (recMatch) =>
                            recMatch.court.idStoreCourt ==
                            Provider.of<DataProvider>(context, listen: false)
                                .courts[index]
                                .idStoreCourt,
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index ==
                                Provider.of<DataProvider>(context,
                                            listen: false)
                                        .courts
                                        .length -
                                    1
                            ? 0
                            : defaultPadding,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              court.description,
                            ),
                          ),
                          Container(
                            width: 80,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: defaultPadding / 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius),
                                color: recurrentMatch != null || !allowRecurrent
                                    ? secondaryYellow
                                    : secondaryGreen),
                            child: Text(
                              recurrentMatch != null || !allowRecurrent
                                  ? "Ocupado"
                                  : "Livre",
                              style: TextStyle(
                                color: textWhite,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: !allowRecurrent
                                ? Text(
                                    "Não permite mensalista nesse dia",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  )
                                : recurrentMatch == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              recurrentMatch.creator.fullName,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              recurrentMatch.sport!.description,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              recurrentMatch.blocked
                                                  ? "Bloqueado pela quadra"
                                                  : "Válido até ${DateFormat('dd/MM').format(recurrentMatch.validUntil!)}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          )
                                        ],
                                      ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Voltar",
                  isPrimary: false,
                  onTap: () {
                    viewModel.returnMainView(context);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
