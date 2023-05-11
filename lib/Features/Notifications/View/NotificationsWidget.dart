import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Notifications/View/NotificationCard.dart';

import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/NotificationsViewModel.dart';

class NotificationsWidget extends StatefulWidget {
  NotificationsViewModel viewModel;
  NotificationsWidget({
    required this.viewModel,
  });

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      child: ListView.builder(
        itemCount: Provider.of<UserProvider>(context, listen: false)
            .notifications
            .length,
        itemBuilder: (context, index) {
          return NotificationCard(
            notification: Provider.of<UserProvider>(context, listen: false)
                .notifications[index],
            onTap: () => widget.viewModel.goToMatch(
              context,
              Provider.of<UserProvider>(context, listen: false)
                  .notifications[index],
            ),
          );
        },
      ),
    );
  }
}
