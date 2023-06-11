import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/AppRecurrentMatch.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

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

  List<AppRecurrentMatch> recurrentMatches = [];

  int? _selectedRecurrentMatch;
  int? get selectedRecurrentMatch => _selectedRecurrentMatch;
  set selectedRecurrentMatch(int? newIndex) {
    _selectedRecurrentMatch = newIndex;
    notifyListeners();
  }

  void initRecurrentMatches(BuildContext context) {
    recurrentMatches =
        Provider.of<UserProvider>(context, listen: false).recurrentMatches;
    notifyListeners();
  }

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
