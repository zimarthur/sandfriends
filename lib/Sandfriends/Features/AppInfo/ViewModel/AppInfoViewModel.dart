import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/Firebase/FirebaseManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/Repository/AppInfoRepo.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/View/DeleteAccountConfirmationModal.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Managers/LocalStorage/LocalStorageManager.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Utils/PageStatus.dart';

class AppInfoViewModel extends ChangeNotifier {
  final appInfoRepo = AppInfoRepo();

  String appVersion = "";

  int timesPressedInfo = 0;
  void pressInfo() async {
    if (timesPressedInfo == 5) {
      timesPressedInfo = 0;
      String? token = await FirebaseManager().getToken();
      if (token != null) {
        await Clipboard.setData(
          ClipboardData(
            text: token,
          ),
        );
      }
    } else {
      timesPressedInfo++;
    }
    notifyListeners();
  }

  void onTapEnableNotifications(BuildContext context) async {
    String? token = await FirebaseManager().getToken();
    if (token != null) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      appInfoRepo
          .setUserNotifications(
        context,
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        Provider.of<UserProvider>(context, listen: false)
            .user!
            .allowNotifications,
        token,
        Provider.of<UserProvider>(context, listen: false)
            .user!
            .allowNotificationsCoupons,
        Provider.of<UserProvider>(context, listen: false)
            .user!
            .allowNotificationsOpenMatches,
      )
          .then((response) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<UserProvider>(context, listen: false)
              .setNotificationsSettings(response.responseBody!);
        } else {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .addModalMessage(
            SFModalMessage(
              title: response.responseTitle!,
              onTap: () {
                Provider.of<StandardScreenViewModel>(context, listen: false)
                    .clearOverlays();
              },
              isHappy: false,
            ),
          );
        }
      });
    }
  }

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

  void onTapLogout(BuildContext context) {
    LocalStorageManager().storeAccessToken(context, "");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login_signup',
      (Route<dynamic> route) => false,
    );
  }

  void onDeleteAccount(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      DeleteAccountConfirmationModal(
        onDelete: () => deleteAccount(context),
        onReturn: () {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .clearOverlays();
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
