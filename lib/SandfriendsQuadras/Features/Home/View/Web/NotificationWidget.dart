import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Home/ViewModel/HomeViewModel.dart';

import '../../../../SharedComponents/Model/AppNotification.dart';
import '../../../../Utils/Constants.dart';
import 'NotificationCard.dart';

class NotificationWidget extends StatelessWidget {
  List<AppNotification> notifications;
  NotificationWidget({
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return Container(
        height: layoutConstraints.maxHeight,
        width: layoutConstraints.maxWidth,
        padding: const EdgeInsets.symmetric(
          vertical: defaultPadding / 2,
          horizontal: defaultPadding,
        ),
        decoration: BoxDecoration(
          color: secondaryPaper,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Últimas atualizações",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textDarkGrey,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(
                    notification: notifications[index],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
