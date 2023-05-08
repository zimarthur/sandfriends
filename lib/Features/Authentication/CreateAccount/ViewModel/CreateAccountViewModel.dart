import 'package:flutter/material.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/View/SFModalMessage.dart';
import '../../../../Utils/PageStatus.dart';
import '../Repo/CreateAccountRepoImp.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final _createAccountRepo = CreateAccountRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  String titleText = "Criar conta";

  final createAccountFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }

  void createAccount(BuildContext context) {
    if (createAccountFormKey.currentState!.validate()) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      _createAccountRepo
          .createAccount(emailController.text, passwordController.text)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          modalMessage = SFModalMessage(
            message: response.responseBody!,
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            isHappy: true,
          );
        } else {
          modalMessage = SFModalMessage(
            message: response.userMessage.toString(),
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
