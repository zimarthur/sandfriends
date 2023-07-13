import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/Model/AppNotification.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/NotificationsRepoImp.dart';

class NotificationsViewModel extends ChangeNotifier {
  final notificationsRepo = NotificationsRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  String titleText = "Notificações";

  void goToMatch(BuildContext context, AppNotification notification) {
    Provider.of<UserProvider>(context, listen: false)
        .notifications
        .firstWhere(
          (notif) => notif.idNotification == notification.idNotification,
        )
        .seen = true;
    Navigator.pushNamed(
        context, '/match_screen/${notification.match.matchUrl}');
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
