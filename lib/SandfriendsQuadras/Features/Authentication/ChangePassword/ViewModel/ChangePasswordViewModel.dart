import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../Repository/ChangePasswordRepo.dart';

class ChangePasswordViewModel extends StandardScreenViewModel {
  void init(BuildContext context, String tokenArg, bool isStoreRequestArg) {
    token = tokenArg;
    isStoreRequest = isStoreRequestArg;
    validateChangePassword(
      context,
    );
  }

  final changePasswordRepo = ChangePasswordRepo();

  String token = "";
  bool isStoreRequest = true;

  final changePasswordFormKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  void validateChangePassword(
    BuildContext context,
  ) {
    if (isStoreRequest) {
      validateChangePasswordTokenEmployee(context);
    } else {
      validateChangePasswordTokenUser(context);
    }
  }

  void changePassword(BuildContext context) {
    if (isStoreRequest) {
      changePasswordEmployee(context);
    } else {
      changePasswordUser(context);
    }
  }

  void validateChangePasswordTokenUser(
    BuildContext context,
  ) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    changePasswordRepo
        .validateChangePasswordTokenUser(context, token)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          onTap: () => validateChangePasswordTokenUser(context),
          isHappy: false,
          buttonText: "Tentar novamente",
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void validateChangePasswordTokenEmployee(
    BuildContext context,
  ) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    changePasswordRepo
        .validateChangePasswordTokenEmployee(context, token)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          description: response.responseDescription,
          onTap: () {},
          hideButton: true,
          isHappy: false,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void changePasswordUser(
    BuildContext context,
  ) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    changePasswordRepo
        .changePasswordUser(context, token, newPasswordController.text)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        final responseBody = json.decode(
          response.responseBody!,
        );
        LocalStorageManager()
            .storeAccessToken(context, responseBody["AccessToken"]);
        modalMessage = SFModalMessage(
          title: "Sua senha foi alterada",
          onTap: () {
            Navigator.pushNamed(context, "/");
          },
          isHappy: true,
        );
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          description: response.responseDescription,
          onTap: () {},
          hideButton: true,
          isHappy: false,
        );
      }

      pageStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void changePasswordEmployee(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    changePasswordRepo
        .changePasswordEmployee(context, token, newPasswordController.text)
        .then((response) {
      modalMessage = SFModalMessage(
        title: response.responseTitle!,
        description: response.responseDescription,
        onTap: () {
          if (response.responseStatus == NetworkResponseStatus.alert) {
            Navigator.pushNamed(context, '/login');
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
}
