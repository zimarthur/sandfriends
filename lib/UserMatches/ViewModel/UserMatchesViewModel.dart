import 'package:flutter/material.dart';
import 'package:sandfriends/UserMatches/Repository/UserMatchesRepoImp.dart';

import '../../SharedComponents/View/SFModalMessage.dart';
import '../../Utils/PageStatus.dart';

class UserMatchesViewModel extends ChangeNotifier {
  final userMatchesRepo = UserMatchesRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget modalForm = Container();

  String titleText = "Minhas Partidas";

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
