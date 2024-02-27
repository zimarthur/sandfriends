import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../../../../Common/Components/SFButton.dart';
import '../../../../../../../Common/Components/SFDivider.dart';
import '../../../../../../../Common/Model/AppMatch/AppMatchStore.dart';
import '../../../../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchStore.dart';
import '../../../../../../../Common/Model/Court.dart';
import '../../../../../../../Common/Model/Hour.dart';
import '../../../../../../../Common/Model/SelectedPayment.dart';
import '../../../../../../../Common/Utils/Constants.dart';
import '../../../../../Menu/ViewModel/StoreProvider.dart';
import '../../../../../Menu/ViewModel/MenuProvider.dart';
import '../../../../ViewModel/CalendarViewModel.dart';
import 'MatchDetailsWidgetRow.dart';
import 'package:collection/collection.dart';

class CourtsAvailabilityWidget extends StatelessWidget {
  CalendarViewModel viewModel;
  Hour hour;
  DateTime day;
  List<AppMatchStore> matches;
  List<AppRecurrentMatchStore> recurrentMatches;

  CourtsAvailabilityWidget({
    super.key,
    required this.viewModel,
    required this.hour,
    required this.day,
    required this.matches,
    required this.recurrentMatches,
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
                  "Partidas do dia",
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
                  value: DateFormat("dd/MM/yyyy").format(day),
                ),
                MatchDetailsWidgetRow(
                  title: "Horário",
                  value:
                      "${hour.hourString} - ${Provider.of<CategoriesProvider>(context, listen: false).hours.firstWhere((hr) => hr.hour > hour.hour).hourString}",
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: SFDivider(),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: Provider.of<StoreProvider>(context, listen: false)
                      .courts
                      .length,
                  itemBuilder: (context, index) {
                    Court court =
                        Provider.of<StoreProvider>(context, listen: false)
                            .courts[index];
                    AppMatchStore? match = matches.firstWhereOrNull((match) =>
                        match.court.idStoreCourt == court.idStoreCourt);
                    AppRecurrentMatchStore? recurrentMatch =
                        recurrentMatches.firstWhereOrNull((recMatch) =>
                            recMatch.court.idStoreCourt == court.idStoreCourt);

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index ==
                                Provider.of<StoreProvider>(context,
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
                          )),
                          Container(
                            width: 80,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: defaultPadding / 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius),
                                color: match != null || recurrentMatch != null
                                    ? secondaryYellow
                                    : secondaryGreen),
                            child: Text(
                              match != null || recurrentMatch != null
                                  ? "Ocupado"
                                  : "Livre",
                              style: TextStyle(
                                color: textWhite,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: match != null
                                      ? Text(
                                          match.matchCreator.fullName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        )
                                      : recurrentMatch != null
                                          ? Text(
                                              recurrentMatch.creator.fullName,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            )
                                          : Container(),
                                ),
                                Expanded(
                                  child: match != null
                                      ? Text(
                                          match.sport != null
                                              ? match.sport!.description
                                              : "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        )
                                      : recurrentMatch != null
                                          ? Text(
                                              recurrentMatch.sport!.description,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            )
                                          : Container(),
                                ),
                                Expanded(
                                  child: match != null
                                      ? Text(
                                          match.blocked
                                              ? "Bloqueado pela quadra"
                                              : match.selectedPayment ==
                                                      SelectedPayment.PayInStore
                                                  ? "Pagar no local"
                                                  : "Pago",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        )
                                      : recurrentMatch != null
                                          ? Text(
                                              recurrentMatch.blocked
                                                  ? "Bloqueado pela quadra"
                                                  : recurrentMatch.nextRecurrentMatches
                                                                  .first.date ==
                                                              day &&
                                                          recurrentMatch
                                                                  .nextRecurrentMatches
                                                                  .first
                                                                  .selectedPayment ==
                                                              SelectedPayment
                                                                  .PayInStore
                                                      ? "Pagar no local"
                                                      : "Pago",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            )
                                          : Container(),
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
