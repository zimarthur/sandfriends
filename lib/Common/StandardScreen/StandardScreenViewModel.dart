import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/PageStatus.dart';

import '../Components/Modal/SFModalMessage.dart';

class StandardScreenViewModel extends ChangeNotifier {
  PageStatus pageStatus = PageStatus.OK;

  SFModalMessage modalMessage = SFModalMessage(
    title: "",
    onTap: () {},
    isHappy: true,
  );

  Widget? widgetForm;
  bool canTapBackground = true;

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
