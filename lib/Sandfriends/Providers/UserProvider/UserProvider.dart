import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/Model/AppNotificationUser.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';

import '../../../Common/Model/AppMatch/AppMatchUser.dart';
import '../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import '../../../Common/Model/CreditCard/CreditCard.dart';
import '../../../Common/Model/Reward.dart';
import '../../../Common/Model/School/School.dart';
import '../../../Common/Model/School/SchoolStore.dart';
import '../../../Common/Model/School/SchoolTeacher.dart';
import '../../../Common/Model/School/SchoolUser.dart';
import '../../../Common/Model/Sport.dart';
import '../../../Common/Model/Teacher.dart';
import '../../../Common/Model/Team.dart';
import '../../../Common/Model/TeamMember.dart';
import '../../../Common/Model/User/UserComplete.dart';
import 'package:geolocator/geolocator.dart';

import '../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../Features/Authentication/LoadLogin/Repository/LoadLoginRepo.dart';

class UserProvider extends ChangeNotifier {
  UserComplete? _user;
  UserComplete? get user => _user;
  set user(UserComplete? newUser) {
    _user = newUser;
    notifyListeners();
  }

  List<Teacher>? availableTeachers;
  List<SchoolUser>? availableSchools;
  bool get needsToLoadClasses =>
      availableSchools == null || availableTeachers == null;

  void setAvailableTeachers(List<Teacher> teachers) {
    if (availableTeachers != null) {
      availableTeachers!.clear();
    }
    availableTeachers = teachers;
    notifyListeners();
  }

  void updateTeamMembers(List<TeamMember> members, Team teamUpdated) {
    if (availableTeachers == null) {
      return;
    }
    for (var teacher in availableTeachers!) {
      for (var team in teacher.teams) {
        if (team.idTeam == teamUpdated.idTeam) {
          team.members = members;
          notifyListeners();
          break;
        }
      }
    }
  }

  void setAvailableSchools(List<SchoolUser> schools) {
    if (availableSchools != null) {
      availableSchools!.clear();
    }
    availableSchools = schools;
    notifyListeners();
  }

  bool _hasSearchUserData = false;
  bool get hasSearchUserData => _hasSearchUserData;
  void setHasSearchUserData(bool value) {
    _hasSearchUserData = value;
    notifyListeners();
  }

  bool get isDoneWithUserRequest => user != null && hasSearchUserData == true;

  bool userNeedsOnboarding() {
    return user != null && user?.firstName == null;
  }

  void logoutUserProvider(BuildContext context) {
    clear();
    _user = null;
    LocalStorageManager().storeAccessToken(context, "");
    notifyListeners();
  }

  void setNotificationsSettings(
    String response,
  ) {
    Map<String, dynamic> responseBody = json.decode(
      response,
    );
    user!.allowNotifications = responseBody["AllowNotifications"];
    user!.notificationsToken = responseBody["NotificationsToken"];
    user!.allowNotificationsCoupons = responseBody["AllowNotificationsCoupons"];
    user!.allowNotificationsOpenMatches =
        responseBody["AllowNotificationsOpenMatches"];
    notifyListeners();
  }

  final List<AppMatchUser> _matches = [];
  List<AppMatchUser> get matches {
    List<AppMatchUser> filteredMatchList;
    filteredMatchList = _matches.where((match) {
      for (int i = 0; i < match.members.length; i++) {
        if (match.members[i].user.id == user!.id) {
          if ((match.members[i].refused == false &&
                  match.members[i].quit == false) ||
              (match.members[i].isMatchCreator)) {
            return true;
          }
        }
      }
      return false;
    }).toList();
    filteredMatchList.sort(
      (a, b) {
        int compare = b.date.compareTo(a.date);

        if (compare == 0) {
          return b.timeBegin.hour.compareTo(a.timeBegin.hour);
        } else {
          return compare;
        }
      },
    );
    return filteredMatchList;
  }

  void clearMatches() {
    _matches.clear();
    notifyListeners();
  }

  void addMatch(AppMatchUser newMatch) {
    _matches.add(newMatch);
    notifyListeners();
  }

  List<AppMatchUser> get nextMatches {
    var filteredList = matches.where((match) {
      if (match.date.isAfter(DateTime.now()) &&
          (match.canceled == false) &&
          (match.isPaymentExpired == false)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    filteredList.sort(
      (a, b) {
        int compare = a.date.compareTo(b.date);

        if (compare == 0) {
          return a.timeBegin.hour.compareTo(b.timeBegin.hour);
        } else {
          return compare;
        }
      },
    );
    return filteredList;
  }

  List<AppMatchUser> get pastMatches {
    var filteredList = matches.where((match) {
      if (match.date.isBefore(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    }).toList();
    filteredList.sort(
      (a, b) {
        int compare = a.date.compareTo(b.date);

        if (compare == 0) {
          return a.timeBegin.hour.compareTo(b.timeBegin.hour);
        } else {
          return compare;
        }
      },
    );
    return filteredList;
  }

  final List<AppRecurrentMatchUser> _recurrentMatches = [];
  List<AppRecurrentMatchUser> get recurrentMatches {
    var filteredList = _recurrentMatches.where((recMatch) {
      if (recMatch.isPaymentExpired == false) {
        return true;
      } else {
        return false;
      }
    }).toList();
    filteredList.sort(
      (a, b) {
        return a.validUntil!.compareTo(b.validUntil!);
      },
    );
    return _recurrentMatches;
  }

  void addRecurrentMatch(AppRecurrentMatchUser newRecurrentMatch) {
    _recurrentMatches.add(newRecurrentMatch);
    notifyListeners();
  }

  final List<AppMatchUser> _openMatches = [];
  List<AppMatchUser> get openMatches {
    _openMatches.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _openMatches;
  }

  void addOpenMatch(AppMatchUser newMatch) {
    _openMatches.add(newMatch);
    notifyListeners();
  }

  Reward? _userReward;
  Reward? get userReward => _userReward;
  void setRewards(Reward? reward, int userQuantity) {
    _userReward = reward;
    _userReward!.userRewardQuantity = userQuantity;
    notifyListeners();
  }

  final List<AppNotificationUser> _notifications = [];
  List<AppNotificationUser> get notifications {
    _notifications.sort(
      (a, b) {
        int compare = b.idNotification.compareTo(a.idNotification);

        if (compare == 0) {
          return b.idNotification.compareTo(a.idNotification);
        } else {
          return compare;
        }
      },
    );
    return _notifications;
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void addNotifications(AppNotificationUser newNotification) {
    _notifications.add(newNotification);
    notifyListeners();
  }

  void clear() {
    _matches.clear();
    _recurrentMatches.clear();
    _notifications.clear();
    _openMatches.clear();
    _userReward = null;
    _creditCards.clear();
    notifyListeners();
  }

  final List<CreditCard> _creditCards = [];
  List<CreditCard> get creditCards => _creditCards;
  void addCreditCard(CreditCard creditCard) {
    _creditCards.add(creditCard);
    notifyListeners();
  }

  void clearCreditCards() {
    _creditCards.clear();
    notifyListeners();
  }

  Position? userLocation;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  bool locationPermanentlyDenied = false;

  Future<bool> handlePositionPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationPermanentlyDenied = true;
      notifyListeners();
      return false;
    }
    userLocation = await _geolocatorPlatform.getCurrentPosition();
    notifyListeners();
    return true;
  }

  void receiveUserDataResponse(BuildContext context, String response) {
    Map<String, dynamic> responseBody = json.decode(
      response,
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
        AppMatchUser.fromJson(
          match,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        ),
      );
    }

    for (var recurrentMatch in responseRecurrentMatches) {
      Provider.of<UserProvider>(context, listen: false).addRecurrentMatch(
        AppRecurrentMatchUser.fromJson(
          recurrentMatch,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
          Provider.of<CategoriesProvider>(context, listen: false).ranks,
          Provider.of<CategoriesProvider>(context, listen: false).genders,
        ),
      );
    }

    for (var openMatch in responseOpenMatches) {
      Provider.of<UserProvider>(context, listen: false).addOpenMatch(
        AppMatchUser.fromJson(
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
        AppNotificationUser.fromJson(
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
  }
}
