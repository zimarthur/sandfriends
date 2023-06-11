import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/OpenMatchesRepoImp.dart';

class OpenMatchesViewModel extends ChangeNotifier {
  final openMatchesRepo = OpenMatchesRepoImp();

  List<AppMatch> openMatches = [];

  void initOpenMatches(BuildContext context) {
    openMatches = Provider.of<UserProvider>(context, listen: false).openMatches;
    notifyListeners();
  }

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  String titleText = "Partidas abertas";

  void onTapOpenMatch(BuildContext context, String matchUrl) {
    Navigator.pushNamed(context, '/match_screen/$matchUrl');
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
