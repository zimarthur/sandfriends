import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppNotification.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends_web/Utils/SFDateTime.dart';
import '../../../../Common/Components/SFAvatar.dart';

class NotificationCard extends StatelessWidget {
  AppNotification notification;
  NotificationCard({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SFAvatar(
                  height: 60,
                  image: notification.match.matchCreatorPhoto,
                  playerFirstName: notification.match.matchCreatorFirstName,
                  playerLastName: notification.match.matchCreatorLastName,
                  isPlayerAvatar: true,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: textDarkGrey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            r"assets/icon/calendar.svg",
                            color: textDarkGrey,
                            height: 12,
                          ),
                          const SizedBox(
                            width: defaultPadding / 4,
                          ),
                          Text(
                            notification.match.idRecurrentMatch != 0
                                ? weekdayRecurrent[getSFWeekday(
                                    notification.match.date.weekday)]
                                : DateFormat("dd/MM/yy")
                                    .format(notification.match.date),
                            style: TextStyle(
                              color: textDarkGrey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          SvgPicture.asset(
                            r"assets/icon/clock.svg",
                            color: textDarkGrey,
                            height: 12,
                          ),
                          const SizedBox(
                            width: defaultPadding / 4,
                          ),
                          Text(
                            "${notification.match.startingHour.hourString} - ${notification.match.endingHour.hourString}",
                            style: TextStyle(
                              color: textDarkGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  "${DateFormat("dd/MM/yy").format(notification.eventTime)}\n${DateFormat("HH:mm").format(notification.eventTime)}",
                  style: TextStyle(
                    color: textLightGrey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            color: divider,
            height: 1,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
