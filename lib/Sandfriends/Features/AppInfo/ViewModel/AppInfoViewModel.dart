import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/Repository/AppInfoRepo.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/View/DeleteAccountConfirmationModal.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Utils/PageStatus.dart';

class AppInfoViewModel extends StandardScreenViewModel {
  final appInfoRepo = AppInfoRepo();

  String appVersion = "";

  void initAppInfo() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      notifyListeners();
    });
  }

  void onTapTerms(BuildContext context) {
    launchUrl(Uri.parse("https://www.sandfriends.com.br/termos"));
  }

  void onTapPrivacy(BuildContext context) {
    launchUrl(Uri.parse("https://www.sandfriends.com.br/politicaprivacidade"));
  }

  void onDeleteAccount(BuildContext context) {
    widgetForm = DeleteAccountConfirmationModal(
      onDelete: () => deleteAccount(context),
      onReturn: () {
        pageStatus = PageStatus.OK;
        notifyListeners();
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void deleteAccount(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    appInfoRepo
        .removeUser(context,
            Provider.of<UserProvider>(context, listen: false).user!.accessToken)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.expiredToken) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login_signup',
          (Route<dynamic> route) => false,
        );
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login_signup',
              (Route<dynamic> route) => false,
            );
          },
          isHappy: false,
        );
        canTapBackground = false;
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }
}