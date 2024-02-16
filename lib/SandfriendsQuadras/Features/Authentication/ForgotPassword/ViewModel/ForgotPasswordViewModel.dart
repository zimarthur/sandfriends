import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../Repository/ForgotPasswordRepo.dart';

class ForgotPasswordViewModel extends StandardScreenViewModel {
  final forgotPasswordRepo = ForgotPasswordRepo();

  final forgotPasswordFormKey = GlobalKey<FormState>();
  TextEditingController forgotPasswordEmailController = TextEditingController();

  void sendForgotPassword(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    forgotPasswordRepo
        .forgotPassword(
      context,
      forgotPasswordEmailController.text,
    )
        .then((response) {
      modalMessage = SFModalMessage(
        title: response.responseTitle!,
        description: response.responseDescription,
        onTap: () {
          if (response.responseStatus == NetworkResponseStatus.alert) {
            goToLogin(context);
          } else {
            pageStatus = PageStatus.OK;
            notifyListeners();
          }
        },
        isHappy: response.responseStatus == NetworkResponseStatus.alert,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
}
