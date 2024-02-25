import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/AppNotificationUser.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../Repository/NotificationsRepoImp.dart';

class NotificationsViewModel extends StandardScreenViewModel {
  final notificationsRepo = NotificationsRepoImp();

  void goToMatch(BuildContext context, AppNotificationUser notification) {
    Provider.of<UserProvider>(context, listen: false)
        .notifications
        .firstWhere(
          (notif) => notif.idNotification == notification.idNotification,
        )
        .seen = true;
    notifyListeners();
    Navigator.pushNamed(
        context, '/match_screen/${notification.match.matchUrl}');
  }
}
