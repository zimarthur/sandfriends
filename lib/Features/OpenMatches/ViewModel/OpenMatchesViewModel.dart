import 'package:flutter/material.dart';

import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/OpenMatchesRepoImp.dart';

class OpenMatchesViewModel extends ChangeNotifier {
  final openMatchesRepo = OpenMatchesRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  String titleText = "Partidas abertas";

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
