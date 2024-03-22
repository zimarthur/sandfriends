import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/Repository/AppInfoRepo.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/View/DeleteAccountConfirmationModal.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Utils/PageStatus.dart';

class AppInfoViewModel extends ChangeNotifier {
  final appInfoRepo = AppInfoRepo();

  String appVersion = "";

  void initAppInfo() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      notifyListeners();
    });
  }

  void onTapTerms(BuildContext context) {
    launchUrl(Uri.parse(termsUse));
  }

  void onTapPrivacy(BuildContext context) {
    launchUrl(Uri.parse(privacyPolicy));
  }

<<<<<<< Updated upstream
=======
  void onTapLogout(BuildContext context) {
    LocalStorageManager().storeAccessToken(context, "");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login_signup',
      (Route<dynamic> route) => false,
    );
  }

>>>>>>> Stashed changes
  void onDeleteAccount(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      DeleteAccountConfirmationModal(
        onDelete: () => deleteAccount(context),
        onReturn: () {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setPageStatusOk();
        },
      ),
    );
  }

  void deleteAccount(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            },
            isHappy: false,
          ),
        );
        //canTapBackground = false;
      }
    });
  }
}
