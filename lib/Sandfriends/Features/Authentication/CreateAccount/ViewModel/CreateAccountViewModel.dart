import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../Repo/CreateAccountRepo.dart';

class CreateAccountViewModel extends StandardScreenViewModel {
  final _createAccountRepo = CreateAccountRepo();

  final createAccountFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }

  void createAccount(BuildContext context) {
    if (createAccountFormKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      _createAccountRepo
          .createAccount(context, emailController.text, passwordController.text)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          modalMessage = SFModalMessage(
            title: response.responseBody!,
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            isHappy: true,
          );
        } else {
          modalMessage = SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              pageStatus = PageStatus.OK;
              notifyListeners();
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          );
        }
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      });
    }
  }
}
