import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Home/View/SeachTypeSelector/SearchTypeEnum.dart';
import 'package:sandfriends/Features/Home/View/SeachTypeSelector/SearchTypeSelectorWidget.dart';
import 'package:sandfriends/Features/MatchSearch/View/MatchSearchWidget.dart';
import 'package:sandfriends/SharedComponents/Model/AppRecurrentMatch.dart';
import 'package:sandfriends/SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/SharedComponents/Providers/RedirectProvider/RedirectProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/Model/AppNotification.dart';
import '../../../SharedComponents/Model/CreditCard/CreditCard.dart';
import '../../../SharedComponents/Model/Reward.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../../Utils/SharedPreferences.dart';
import '../Model/HomeTabsEnum.dart';
import '../Repository/HomeRepoImp.dart';
import '../View/Feed/FeedWidget.dart';
import '../View/User/AppRatingModal.dart';
import '../View/User/UserWidget.dart';

class HomeViewModel extends ChangeNotifier {
  final homeRepo = HomeRepoImp();

  PageStatus pageStatus = PageStatus.LOADING;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;
  bool canTapBackground = true;

  void changeTab(BuildContext context, HomeTabs newTab) {
    currentTab = newTab;

    switch (currentTab) {
      case HomeTabs.User:
        displayWidget = UserWidget(
          viewModel: this,
        );
      case HomeTabs.MatchSearch:
        displayWidget = SearchTypeSelectorWidget(
          onSelect: (searchType) {
            switch (searchType) {
              case SearchType.Default:
                goToMatchSearchScreen(context);

                break;
              case SearchType.ByStore:
                goToStoreSearchScreen(context);
                break;
            }
          },
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

    configureNotifications().then((notificationCOnfigs) {
      getUserInfo(context, notificationCOnfigs);
      notifyListeners();
    });
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

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void getUserInfo(
    BuildContext context,
    Tuple2<bool?, String?>? notificationsConfig,
  ) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    homeRepo
        .getUserInfo(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      notificationsConfig,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<UserProvider>(context, listen: false).clear();

        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        final responseMatchCounter = responseBody['MatchCounter'];
        final responseMatches = responseBody['UserMatches'];
        final responseRecurrentMatches = responseBody['UserRecurrentMatches'];
        final responseOpenMatches = responseBody['OpenMatches'];
        final responseNotifications = responseBody['Notifications'];
        final responseRewards = responseBody['UserRewards'];
        final responseCreditCards = responseBody['CreditCards'];

        Provider.of<UserProvider>(context, listen: false)
            .user!
            .matchCounterFromJson(responseMatchCounter);

        for (var match in responseMatches) {
          Provider.of<UserProvider>(context, listen: false).addMatch(
            AppMatch.fromJson(
              match,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }

        for (var recurrentMatch in responseRecurrentMatches) {
          Provider.of<UserProvider>(context, listen: false).addRecurrentMatch(
            AppRecurrentMatch.fromJson(
              recurrentMatch,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }

        for (var openMatch in responseOpenMatches) {
          Provider.of<UserProvider>(context, listen: false).addOpenMatch(
            AppMatch.fromJson(
              openMatch,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }

        Provider.of<UserProvider>(context, listen: false).setRewards(
            Reward.fromJson(responseRewards['Reward']),
            responseRewards['UserRewardQuantity']);

        for (var appNotification in responseNotifications) {
          Provider.of<UserProvider>(context, listen: false).addNotifications(
            AppNotification.fromJson(
              appNotification,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }
        for (var creditCard in responseCreditCards) {
          Provider.of<UserProvider>(context, listen: false).addCreditCard(
            CreditCard.fromJson(
              creditCard,
            ),
          );
        }
        if (Provider.of<RedirectProvider>(context, listen: false).redirectUri !=
            null) {
          Navigator.pushNamed(
              context,
              Provider.of<RedirectProvider>(context, listen: false)
                  .redirectUri!);
          Provider.of<RedirectProvider>(context, listen: false).redirectUri =
              null;
        }
        canTapBackground = true;
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.expiredToken) {
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
        );
        canTapBackground = false;
        pageStatus = PageStatus.ERROR;
        notifyListeners();
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
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    homeRepo
        .sendFeedback(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      feedbackController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage.toString(),
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.expiredToken) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            } else {
              pageStatus = PageStatus.OK;
              notifyListeners();
            }
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        );
        if (response.responseStatus == NetworkResponseStatus.expiredToken) {
          canTapBackground = false;
        }
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
      feedbackController.text = "";
    });
  }

  void contactSupport() {
    final url = Uri.parse("whatsapp://send?phone=$whatsApp");
    launchUrl(url);
  }

  void openAppRatingModal() {
    widgetForm = AppRatingModal(
      viewModel: this,
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
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
    setAccessToken(context, "");
    Navigator.pushNamed(context, '/login_signup');
  }

  void goToMatchSearchScreen(
    BuildContext context,
  ) {
    Navigator.pushNamed(context, '/match_search', arguments: {
      'sportId': Provider.of<UserProvider>(context, listen: false)
          .user!
          .preferenceSport!
          .idSport,
    });
  }

  void goToStoreSearchScreen(
    BuildContext context,
  ) {
    Navigator.pushNamed(context, '/store_search', arguments: {
      'sportId': Provider.of<UserProvider>(context, listen: false)
          .user!
          .preferenceSport!
          .idSport,
    });
  }

  void showAppInfoModal(BuildContext context) {
    Navigator.pushNamed(context, "/app_info");
  }
}
