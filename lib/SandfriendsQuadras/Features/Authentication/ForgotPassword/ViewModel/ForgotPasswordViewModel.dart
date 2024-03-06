import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../Repository/ForgotPasswordRepo.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final forgotPasswordRepo = ForgotPasswordRepo();

  final forgotPasswordFormKey = GlobalKey<FormState>();
  TextEditingController forgotPasswordEmailController = TextEditingController();

  void sendForgotPassword(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    forgotPasswordRepo
        .forgotPassword(
      context,
      forgotPasswordEmailController.text,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: response.responseTitle!,
          description: response.responseDescription,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.alert) {
              goToLogin(context);
            }
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        ),
      );
    });
  }

  void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
}
