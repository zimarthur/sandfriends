import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../SharedComponents/Model/AppNotification.dart';
import '../../../SharedComponents/View/SFAvatar.dart';
import '../../../Utils/Constants.dart';

class NotificationCard extends StatefulWidget {
  AppNotification notification;
  VoidCallback onTap;
  NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.notification.seen
                ? primaryLightBlue.withOpacity(0.5)
                : primaryLightBlue,
            width: 1,
          ),
          color: widget.notification.seen
              ? primaryLightBlue.withOpacity(0.1)
              : primaryLightBlue.withOpacity(0.6),
        ),
        margin: EdgeInsets.symmetric(
            vertical: height * 0.005, horizontal: width * 0.02),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.2,
              child: Stack(
                children: [
                  SFAvatar(
                      height: width * 0.2,
                      user: widget.notification.user,
                      showRank: false),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: width * 0.06,
                      width: width * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(int.parse(
                              "0xFF${widget.notification.colorString.replaceAll("#", "")}"))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: width * 0.04,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: width * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.notification.message,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(r"assets/icon/calendar.svg"),
                            Padding(
                              padding: EdgeInsets.only(
                                right: width * 0.02,
                              ),
                            ),
                            Text(
                              "${DateFormat("dd/MM/yyyy").format(widget.notification.match.date)} às ${widget.notification.match.timeBegin.hourString}",
                              style: const TextStyle(
                                color: textBlue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(r"assets/icon/location_ping.svg"),
                            Padding(
                              padding: EdgeInsets.only(
                                right: width * 0.02,
                              ),
                            ),
                            const Text(
                              "Beach Brasil",
                              style: TextStyle(
                                color: textBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
