import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../Repository/EmailConfirmationRepo.dart';

class EmailConfirmationViewModel extends ChangeNotifier {
  void initEmailConfirmationViewModel(
      BuildContext context, String tokenUrl, bool isStoreRequestUrl) {
    token = tokenUrl;
    isStoreRequest = isStoreRequestUrl;
    if (isStoreRequest) {
      validateTokenStore(context);
    } else {
      validateTokenUser(
        context,
      );
    }
  }

  final emailConfirmationRepo = EmailConfirmationRepo();

  String token = "";
  bool isStoreRequest = true;

  void validateTokenUser(
    BuildContext context,
  ) {
    emailConfirmationRepo
        .emailConfirmationUser(context, token)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            description: response.responseDescription,
            onTap: () {},
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
            hideButton: response.responseStatus == NetworkResponseStatus.error,
          ),
        );
      }
    });
  }

  void validateTokenStore(BuildContext context) {
    emailConfirmationRepo
        .emailConfirmationStore(context, token)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            description: response.responseDescription!,
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
            buttonText: "login",
          ),
        );
      }
    });
  }

  void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
}
