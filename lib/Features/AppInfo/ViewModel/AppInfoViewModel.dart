import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/AppInfo/Repository/AppInfoRepoImp.dart';
import 'package:sandfriends/Features/AppInfo/View/DeleteAccountConfirmationModal.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';

class AppInfoViewModel extends ChangeNotifier {
  final appInfoRepo = AppInfoRepoImp();

  bool canTapBackground = true;
  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;

  String appVersion = "";

  void initAppInfo() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      notifyListeners();
    });
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
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
          message: response.userMessage!,
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
