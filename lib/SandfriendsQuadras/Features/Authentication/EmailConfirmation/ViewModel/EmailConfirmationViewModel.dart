import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../Repository/EmailConfirmationRepo.dart';

class EmailConfirmationViewModel extends StandardScreenViewModel {
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
        pageStatus = PageStatus.OK;
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          description: response.responseDescription,
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
          hideButton: response.responseStatus == NetworkResponseStatus.error,
        );
        pageStatus = PageStatus.ERROR;
      }
      notifyListeners();
    });
  }

  void validateTokenStore(BuildContext context) {
    emailConfirmationRepo
        .emailConfirmationStore(context, token)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        pageStatus = PageStatus.OK;
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          description: response.responseDescription!,
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
          buttonText: "login",
        );
        pageStatus = PageStatus.ERROR;
      }
      notifyListeners();
    });
  }

  void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
}
