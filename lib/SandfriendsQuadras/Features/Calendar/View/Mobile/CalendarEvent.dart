import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import '../../../../../Common/Model/Court.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/SFDateTime.dart';
import '../../Model/DayMatch.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Model/HourInformation.dart';
import '../../ViewModel/CalendarViewModel.dart';

class CalendarEvent extends StatelessWidget {
  DayMatch dayMatch;
  Court court;
  CalendarViewModel viewModel;
  VoidCallback onTapDayMatch;
  CalendarEvent({
    required this.dayMatch,
    required this.court,
    required this.viewModel,
    required this.onTapDayMatch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool hasEvent = dayMatch.match != null || dayMatch.recurrentMatch != null;

    if (hasEvent) {
      Color primaryColor = textDarkGrey;
      Color secondaryColor = textDarkGrey;

      if (dayMatch.match != null) {
        if (dayMatch.match!.blocked) {
          primaryColor = secondaryYellowDark;
          secondaryColor = secondaryYellowDark50;
        } else if (!dayMatch.match!.isFromRecurrentMatch) {
          primaryColor = match;
          secondaryColor = matchBg;
        } else {
          primaryColor = recurrentMatch;
          secondaryColor = recurrentMatchBg;
        }
      } else {
        if (dayMatch.recurrentMatch!.blocked) {
          primaryColor = secondaryYellowDark;
          secondaryColor = secondaryYellowDark50;
        } else {
          primaryColor = recurrentMatch;
          secondaryColor = recurrentMatchBg;
        }
      }

      return InkWell(
        onTap: () {
          onTapDayMatch();
          viewModel.onTapHour(
            HourInformation(
              match: dayMatch.match != null,
              recurrentMatch: dayMatch.recurrentMatch != null,
              creatorName: dayMatch.match != null &&
                      !dayMatch.match!.isFromRecurrentMatch
                  ? "Partida de ${dayMatch.match!.matchCreator.fullName}"
                  : "Mensalista de ${dayMatch.match != null ? dayMatch.match!.matchCreator.fullName : dayMatch.recurrentMatch!.creator.fullName}",
              timeBegin: dayMatch.match != null
                  ? dayMatch.match!.timeBegin
                  : dayMatch.recurrentMatch!.timeBegin,
              timeEnd: dayMatch.match != null
                  ? dayMatch.match!.timeEnd
                  : dayMatch.recurrentMatch!.timeEnd,
              sport: dayMatch.match != null
                  ? dayMatch.match!.sport
                  : dayMatch.recurrentMatch!.sport,
              cost: dayMatch.match != null
                  ? dayMatch.match!.cost
                  : dayMatch.recurrentMatch!.matchCost,
              payInStore: dayMatch.match != null
                  ? dayMatch.match!.payInStore
                  : dayMatch.recurrentMatch!.payInStore,
              refMatch: dayMatch.match,
              refRecurrentMatch: dayMatch.recurrentMatch,
              court: court,
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.all(
            defaultPadding / 4,
          ),
          padding: EdgeInsets.all(
            defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
            color: secondaryColor,
          ),
          child: Row(
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                ),
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayMatch.match != null
                          ? dayMatch.match!.matchCreator.fullName
                          : dayMatch.recurrentMatch!.creator.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dayMatch.match != null
                          ? dayMatch.match!.sport!.description
                          : dayMatch.recurrentMatch!.sport!.description,
                      style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 10,
                      ),
                    ),
                    if (dayMatch.match != null)
                      Row(
                        children: [
                          Text(
                            dayMatch.match!.cost.formatPrice(),
                            style: TextStyle(
                              color: textDarkGrey,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(
                            width: defaultPadding / 4,
                          ),
                          dayMatch.match!.payInStore
                              ? SvgPicture.asset(
                                  r"assets/icon/needs_payment.svg",
                                  height: 15,
                                )
                              : SvgPicture.asset(
                                  r"assets/icon/already_paid.svg",
                                  height: 15,
                                )
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onTapDayMatch();
          viewModel.onTapHour(
            HourInformation(
              creatorName: "Horário livre",
              timeBegin: dayMatch.startingHour,
              timeEnd: viewModel.availableHours.firstWhere(
                (hour) => hour.hour > dayMatch.startingHour.hour,
              ),
              freeHour: true,
              court: court,
            ),
          );
        },
        child: viewModel.hourInformation != null
            ? viewModel.hourInformation!.court.idStoreCourt ==
                        court.idStoreCourt &&
                    viewModel.hourInformation!.timeBegin.hour ==
                        dayMatch.startingHour.hour
                ? InkWell(
                    onTap: () {
                      if (!isHourPast(
                        viewModel.selectedDay,
                        dayMatch.startingHour,
                      )) {
                        viewModel.setAddMatchWidget(
                          context,
                          court,
                          dayMatch.startingHour,
                          viewModel.availableHours.firstWhere(
                            (hour) => hour.hour > dayMatch.startingHour.hour,
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(
                        defaultPadding / 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                        border: Border.all(color: greenText, width: 2),
                        color: greenBg,
                      ),
                      child: Center(
                        child: Text(
                          isHourPast(
                            viewModel.selectedDay,
                            dayMatch.startingHour,
                          )
                              ? ""
                              : "+",
                          style: TextStyle(
                            color: greenText,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container()
            : Container(),
      );
    }
  }
}
