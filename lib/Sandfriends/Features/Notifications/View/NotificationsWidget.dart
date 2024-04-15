import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/Notifications/View/NotificationCard.dart';

import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/NotificationsViewModel.dart';

class NotificationsWidget extends StatefulWidget {
  final NotificationsViewModel viewModel;
  const NotificationsWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      child: Provider.of<UserProvider>(context, listen: false)
              .notifications
              .isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: Provider.of<UserProvider>(context, listen: false)
                  .notifications
                  .length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  notification:
                      Provider.of<UserProvider>(context).notifications[index],
                  onTap: () => widget.viewModel.goToMatch(
                    context,
                    Provider.of<UserProvider>(context, listen: false)
                        .notifications[index],
                  ),
                );
              },
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "Você não tem notificações.",
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
