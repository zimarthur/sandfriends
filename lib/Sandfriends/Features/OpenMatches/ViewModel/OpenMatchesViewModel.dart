import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Model/AppMatch/AppMatchUser.dart';
import '../Repository/OpenMatchesRepoImp.dart';

class OpenMatchesViewModel extends ChangeNotifier {
  final openMatchesRepo = OpenMatchesRepoImp();

  List<AppMatchUser> openMatches = [];

  void initOpenMatches(BuildContext context) {
    openMatches = Provider.of<UserProvider>(context, listen: false).openMatches;
    notifyListeners();
  }

  void onTapOpenMatch(BuildContext context, String matchUrl) {
    Navigator.pushNamed(context, '/match_screen/$matchUrl');
  }
}
