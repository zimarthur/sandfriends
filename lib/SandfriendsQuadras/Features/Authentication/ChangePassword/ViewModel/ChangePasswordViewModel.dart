import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../Repository/ChangePasswordRepo.dart';

class ChangePasswordViewModel extends ChangeNotifier {
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
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    changePasswordRepo
        .validateChangePasswordTokenUser(context, token)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () => validateChangePasswordTokenUser(context),
            isHappy: false,
            buttonText: "Tentar novamente",
          ),
        );
      }
    });
  }

  void validateChangePasswordTokenEmployee(
    BuildContext context,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    changePasswordRepo
        .validateChangePasswordTokenEmployee(context, token)
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
            hideButton: true,
            isHappy: false,
          ),
        );
      }
    });
  }

  void changePasswordUser(
    BuildContext context,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    changePasswordRepo
        .changePasswordUser(context, token, newPasswordController.text)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        final responseBody = json.decode(
          response.responseBody!,
        );
        LocalStorageManager()
            .storeAccessToken(context, responseBody["AccessToken"]);
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: "Sua senha foi alterada",
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
            isHappy: true,
          ),
        );
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            description: response.responseDescription,
            onTap: () {},
            hideButton: true,
            isHappy: false,
          ),
        );
      }
    });
  }

  void changePasswordEmployee(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    changePasswordRepo
        .changePasswordEmployee(context, token, newPasswordController.text)
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: response.responseTitle!,
          description: response.responseDescription,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.alert) {
              Navigator.pushNamed(context, '/login');
            }
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        ),
      );
    });
  }
}
