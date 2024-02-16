import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Model/AppMatch.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../Repository/OpenMatchesRepoImp.dart';

class OpenMatchesViewModel extends StandardScreenViewModel {
  final openMatchesRepo = OpenMatchesRepoImp();

  List<AppMatch> openMatches = [];

  void initOpenMatches(BuildContext context) {
    openMatches = Provider.of<UserProvider>(context, listen: false).openMatches;
    notifyListeners();
  }

  void onTapOpenMatch(BuildContext context, String matchUrl) {
    Navigator.pushNamed(context, '/match_screen/$matchUrl');
  }
}
