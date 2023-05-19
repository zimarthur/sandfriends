import 'package:flutter/material.dart';

import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/RecurrentMatchesRepoImp.dart';

class RecurrentMatchesViewModel extends ChangeNotifier {
  final recurrentMatchesRepo = RecurrentMatchesRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  void goToSportSelection(BuildContext context) {
    Navigator.pushNamed(context, '/recurrent_match_search_sport');
  }
}
