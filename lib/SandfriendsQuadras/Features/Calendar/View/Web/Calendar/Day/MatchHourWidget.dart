import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchStore.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import '../../../../../../../Common/Model/AppMatch/AppMatch.dart';
import '../../../../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatch.dart';
import '../../../../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchStore.dart';
import '../../../../../../../Common/Utils/Constants.dart';
import '../../../../../../../Common/Utils/SFDateTime.dart';
import '../../../../Model/CalendarType.dart';

class MatchHourWidget extends StatefulWidget {
  VoidCallback onTapMatch;
  VoidCallback onUnblockHour;
  AppMatchStore? match;
  AppRecurrentMatchStore? recurrentMatch;
  CalendarType calendarType;
  DateTime selectedDate;

  MatchHourWidget({
    required this.onTapMatch,
    required this.onUnblockHour,
    required this.match,
    required this.recurrentMatch,
    required this.calendarType,
    required this.selectedDate,
  });

  @override
  State<MatchHourWidget> createState() => _MatchHourWidgetState();
}

class _MatchHourWidgetState extends State<MatchHourWidget> {
  bool buttonExpanded = false;
  bool isOnHover = false;

  late String title;
  late String sport;
  late bool blocked;
  late String timeBegin;
  late String timeEnd;
  late bool canBlockUnblock;
  String observation = "";

  @override
  Widget build(BuildContext context) {
    if (widget.match != null) {
      canBlockUnblock =
          !isHourPast(widget.match!.date, widget.match!.timeBegin);
      blocked = widget.match!.blocked;
      timeBegin = widget.match!.timeBegin.hourString;
      timeEnd = widget.match!.timeEnd.hourString;
      title =
          "${widget.match!.isFromRecurrentMatch ? "Mensalista" : "Partida"} de ${widget.match!.matchCreator.fullName}";
      sport = widget.match!.sport!.description;
      if (blocked) {
        observation = widget.match!.blockedReason;
      } else {
        observation = widget.match!.creatorNotes;
      }
    } else {
      blocked = widget.recurrentMatch!.blocked;
      canBlockUnblock =
          !isHourPast(widget.selectedDate, widget.recurrentMatch!.timeBegin) ||
              widget.calendarType == CalendarType.RecurrentMatch;
      sport = widget.recurrentMatch!.sport.description;
      timeBegin = widget.recurrentMatch!.timeBegin.hourString;
      timeEnd = widget.recurrentMatch!.timeEnd.hourString;
      observation = blocked ? widget.recurrentMatch!.blockedReason : "";
      title = "Mensalista de ${widget.recurrentMatch!.creator.fullName}";
    }
    return LayoutBuilder(
      builder: (layourContext, layoutConstraints) {
        return InkWell(
          onTap: () {
            if (blocked == false) {
              widget.onTapMatch();
            }
          },
          mouseCursor: blocked == false
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onHover: (value) {
            setState(() {
              isOnHover = value;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: blocked
                      ? [
                          secondaryYellow.withOpacity(0.6),
                          secondaryYellow.withOpacity(0.3),
                          secondaryYellow.withOpacity(0.2),
                        ]
                      : [
                          primaryLightBlue.withOpacity(0.6),
                          primaryLightBlue.withOpacity(0.3),
                          primaryLightBlue.withOpacity(0.2),
                        ],
                ),
              ),
              margin: EdgeInsets.symmetric(
                  vertical: defaultPadding / 4, horizontal: defaultPadding / 2),
              padding: EdgeInsets.symmetric(
                  vertical: defaultPadding / 2, horizontal: defaultPadding),
              width: double.infinity,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              color: blocked
                                  ? secondaryYellowDark
                                  : primaryDarkBlue,
                            ),
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          if (observation.isNotEmpty)
                            Tooltip(
                              message: observation,
                              child: SvgPicture.asset(
                                r"assets/icon/info.svg",
                                height: 20,
                                color: blocked
                                    ? secondaryYellowDark
                                    : primaryDarkBlue,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        "$timeBegin - $timeEnd | $sport",
                        style: TextStyle(
                          color: textDarkGrey,
                          fontSize: 12,
                        ),
                      ),
                      if (widget.match != null)
                        Row(
                          children: [
                            Text(
                              widget.match!.cost.formatPrice(),
                              style: TextStyle(
                                color: textDarkGrey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: defaultPadding / 4,
                            ),
                            widget.match!.payInStore
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
                  if (isOnHover && blocked && canBlockUnblock)
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: widget.onUnblockHour,
                        onHover: (value) {
                          setState(() {
                            buttonExpanded = value;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            color: textWhite,
                          ),
                          padding:
                              EdgeInsets.all(layoutConstraints.maxHeight * 0.1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                r"assets/icon/check_circle.svg",
                                color: green,
                              ),
                              if (buttonExpanded)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: layoutConstraints.maxHeight * 0.1,
                                    ),
                                    Text(
                                      "Liberar Horário",
                                      style: TextStyle(color: green),
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        );
      },
    );
  }
}
