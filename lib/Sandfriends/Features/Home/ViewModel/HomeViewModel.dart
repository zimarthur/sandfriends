import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerManager.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/Model/AppNotificationUser.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/SearchType/View/SearchTypeScreen.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatch.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/RedirectProvider/RedirectProvider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../Common/Model/AppMatch/AppMatchUser.dart';
import '../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/CreditCard/CreditCard.dart';
import '../../../../Common/Model/Reward.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../Model/HomeTabsEnum.dart';
import '../Repository/HomeRepo.dart';
import '../View/Feed/FeedWidget.dart';
import '../View/User/AppRatingModal.dart';
import '../View/User/UserWidget.dart';

class HomeViewModel extends ChangeNotifier {
  final homeRepo = HomeRepo();

  void changeTab(BuildContext context, HomeTabs newTab) {
    currentTab = newTab;

    switch (currentTab) {
      case HomeTabs.User:
        displayWidget = UserWidget(
          viewModel: this,
        );
      case HomeTabs.MatchSearch:
        displayWidget = SearchTypeScreen(
          isRecurrent: false,
        );

      default:
        displayWidget = FeedWidget(
          viewModel: this,
        );
    }

    notifyListeners();
  }

  late HomeTabs currentTab;

  late Widget displayWidget;

  void initHomeScreen(HomeTabs initialTab, BuildContext context) {
    changeTab(context, initialTab);

    if (!kIsWeb) {
      configureNotifications().then((notificationCOnfigs) {
        getUserInfo(context, notificationCOnfigs);
        notifyListeners();
      });
    } else {
      getUserInfo(context, null);
    }
  }

  Future<Tuple2<bool, String?>?> configureNotifications() async {
    bool? authorization;
    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      print("token is ${fcmToken}");
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      authorization =
          settings.authorizationStatus == AuthorizationStatus.authorized
              ? true
              : settings.authorizationStatus == AuthorizationStatus.denied
                  ? false
                  : null;
    } catch (e) {}

    return authorization != null
        ? Tuple2<bool, String?>(authorization, fcmToken)
        : null;
  }

  void getUserInfo(
    BuildContext context,
    Tuple2<bool?, String?>? notificationsConfig,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    homeRepo
        .getUserInfo(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      notificationsConfig,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<UserProvider>(context, listen: false).clear();

        Provider.of<UserProvider>(context, listen: false)
            .receiveUserDataResponse(context, response.responseBody!);

        if (Provider.of<RedirectProvider>(context, listen: false).redirectUri !=
            null) {
          Navigator.pushNamed(
              context,
              Provider.of<RedirectProvider>(context, listen: false)
                  .redirectUri!);
          Provider.of<RedirectProvider>(context, listen: false).redirectUri =
              null;
        }
        //canTapBackground = true;
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              } else {
                getUserInfo(context, notificationsConfig);
              }
            },
            isHappy: false,
            buttonText:
                response.responseStatus == NetworkResponseStatus.expiredToken
                    ? "Concluído"
                    : "Tentar novamente",
          ),
        );
        //canTapBackground = false;
      }
    });
  }

  final feedbackFormKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();

  void validateFeedback(BuildContext context) {
    if (feedbackFormKey.currentState?.validate() == true) {
      sendFeedback(context);
    }
  }

  void sendFeedback(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    homeRepo
        .sendFeedback(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      feedbackController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .clearOverlays();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              } else {
                Provider.of<StandardScreenViewModel>(context, listen: false)
                    .setPageStatusOk();
                Provider.of<StandardScreenViewModel>(context, listen: false)
                    .clearOverlays();
              }
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
        if (response.responseStatus == NetworkResponseStatus.expiredToken) {
          //canTapBackground = false;
        }
      }
      feedbackController.text = "";
    });
  }

  void contactSupport(BuildContext context) {
    LinkOpenerManager().openSandfriendsWhatsApp(context);
  }

  void openAppRatingModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      AppRatingModal(
        viewModel: this,
      ),
    );
  }

  void goToUSerDetail(BuildContext context) {
    Navigator.pushNamed(context, '/user_details');
  }

  void goToUserMatchScreen(BuildContext context) {
    Navigator.pushNamed(context, '/user_matches');
  }

  void goToNotificationScreen(BuildContext context) {
    Navigator.pushNamed(context, '/notifications');
  }

  void logOff(BuildContext context) {
    LocalStorageManager().storeAccessToken(context, "");
    Navigator.pushNamed(context, '/login_signup');
  }

  void showAppInfoModal(BuildContext context) {
    Navigator.pushNamed(context, "/app_info");
  }
}
