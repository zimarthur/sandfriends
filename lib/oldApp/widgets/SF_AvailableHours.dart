import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/oldApp/providers/match_provider.dart';

import '../models/court_available_hours.dart';
import '../theme/app_theme.dart';

class SFAvailableHours extends StatefulWidget {
  List<CourtAvailableHours> availableHours;
  final int widgetIndexTime;
  final int widgetIndexStore;
  final bool multipleSelection;
  final bool isRecurrentMatch;

  SFAvailableHours(
      {required this.availableHours,
      required this.widgetIndexTime,
      required this.widgetIndexStore,
      required this.multipleSelection,
      this.isRecurrentMatch = false});

  @override
  State<SFAvailableHours> createState() => _SFAvailableHoursState();
}

class _SFAvailableHoursState extends State<SFAvailableHours> {
  bool isSelectedHour(BuildContext context) {
    //para o match search screen (cada court ali seria um estabelecimento)
    if ((Provider.of<MatchProvider>(context).indexSelectedCourt ==
            widget.widgetIndexStore) &&
        (Provider.of<MatchProvider>(context).selectedTime.any((element) =>
            element.hourIndex ==
            widget.availableHours[widget.widgetIndexTime].hourIndex))) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.multipleSelection) {
            // for (int i = 0; i < widget.widgetIndexTime + 1; i++) {
            //   Provider.of<MatchProvider>(context, listen: false)
            //       .indexSelectedTime
            //       .add(i);
            //   Provider.of<MatchProvider>(context, listen: false)
            //       .selectedTime
            //       .add(widget.availableHours[i]);
            // }

            //obtem maiores e menores horas selecionadas
            int minValue = 0;
            int maxValue = 0;
            if (Provider.of<MatchProvider>(context, listen: false)
                .selectedTime
                .isNotEmpty) {
              minValue = Provider.of<MatchProvider>(context, listen: false)
                  .selectedTime
                  .reduce((a, b) => a.hourIndex < b.hourIndex ? a : b)
                  .hourIndex;
              maxValue = Provider.of<MatchProvider>(context, listen: false)
                  .selectedTime
                  .reduce((a, b) => a.hourIndex > b.hourIndex ? a : b)
                  .hourIndex;
            }

            //verifica se o horario clicado é igual ao max +1 ou min - 1
            if ((widget.availableHours[widget.widgetIndexTime].hourIndex >
                            maxValue + 1 ||
                        widget.availableHours[widget.widgetIndexTime]
                                .hourIndex <
                            minValue - 1 ||
                        (widget.availableHours[widget.widgetIndexTime]
                                    .hourIndex <
                                maxValue &&
                            widget.availableHours[widget.widgetIndexTime]
                                    .hourIndex >
                                minValue)) &&
                    Provider.of<MatchProvider>(context, listen: false)
                        .selectedTime
                        .isNotEmpty ||
                (Provider.of<MatchProvider>(context, listen: false)
                        .indexSelectedCourt !=
                    widget.widgetIndexStore)) {
              Provider.of<MatchProvider>(context, listen: false)
                  .selectedTime
                  .clear();

              Provider.of<MatchProvider>(context, listen: false)
                  .selectedTime
                  .add(widget.availableHours[widget.widgetIndexTime]);
            } else {
              //verifica se o horario clicado ja tava selecionado
              if (Provider.of<MatchProvider>(context, listen: false)
                  .selectedTime
                  .any((element) =>
                      element.hourIndex ==
                      widget
                          .availableHours[widget.widgetIndexTime].hourIndex)) {
                Provider.of<MatchProvider>(context, listen: false)
                    .selectedTime
                    .removeWhere((element) =>
                        element.hourIndex ==
                        widget
                            .availableHours[widget.widgetIndexTime].hourIndex);
              } else {
                Provider.of<MatchProvider>(context, listen: false)
                    .selectedTime
                    .add(widget.availableHours[widget.widgetIndexTime]);
              }
            }
            Provider.of<MatchProvider>(context, listen: false)
                .selectedTime
                .sort(
              (a, b) {
                int compare = a.hourIndex.compareTo(b.hourIndex);

                if (compare == 0) {
                  return a.hourIndex.compareTo(b.hourIndex);
                } else {
                  return compare;
                }
              },
            );
          } else {
            Provider.of<MatchProvider>(context, listen: false)
                .selectedTime
                .clear();

            Provider.of<MatchProvider>(context, listen: false)
                .selectedTime
                .add(widget.availableHours[widget.widgetIndexTime]);
          }
          Provider.of<MatchProvider>(context, listen: false)
              .indexSelectedCourt = widget.widgetIndexStore;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          width: 75,
          decoration: BoxDecoration(
            color: isSelectedHour(context)
                ? widget.isRecurrentMatch
                    ? AppTheme.colors.primaryLightBlue
                    : AppTheme.colors.primaryBlue
                : AppTheme.colors.secondaryPaper,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: widget.isRecurrentMatch
                    ? AppTheme.colors.primaryLightBlue
                    : AppTheme.colors.primaryBlue,
                width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      r"assets\icon\clock.svg",
                      color: isSelectedHour(context)
                          ? AppTheme.colors.textWhite
                          : widget.isRecurrentMatch
                              ? AppTheme.colors.primaryLightBlue
                              : AppTheme.colors.primaryBlue,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.availableHours[widget.widgetIndexTime].hour,
                          style: TextStyle(
                            color: isSelectedHour(context)
                                ? AppTheme.colors.textWhite
                                : widget.isRecurrentMatch
                                    ? AppTheme.colors.primaryLightBlue
                                    : AppTheme.colors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      r"assets\icon\payment.svg",
                      color: isSelectedHour(context)
                          ? AppTheme.colors.textWhite
                          : widget.isRecurrentMatch
                              ? AppTheme.colors.primaryLightBlue
                              : AppTheme.colors.primaryBlue,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${widget.availableHours[widget.widgetIndexTime].price}/h",
                          style: TextStyle(
                            color: isSelectedHour(context)
                                ? AppTheme.colors.textWhite
                                : widget.isRecurrentMatch
                                    ? AppTheme.colors.primaryLightBlue
                                    : AppTheme.colors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
