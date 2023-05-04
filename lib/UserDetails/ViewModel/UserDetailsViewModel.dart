import 'package:flutter/material.dart';
import 'package:sandfriends/UserDetails/Repository/UserDetailsRepoImp.dart';

import '../../SharedComponents/View/SFModalMessage.dart';
import '../../Utils/PageStatus.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final userDetailsRepo = UserDetailsRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget modalForm = Container();

  String titleText = "Meu Perfil";

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
