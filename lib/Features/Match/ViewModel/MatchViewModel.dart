import 'package:flutter/material.dart';

import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/MatchRepoImp.dart';

class MatchViewModel extends ChangeNotifier {
  final matchRepo = MatchRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  late String titleText;
  late AppMatch match;

  void initMatchViewModel() {}

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }
}
