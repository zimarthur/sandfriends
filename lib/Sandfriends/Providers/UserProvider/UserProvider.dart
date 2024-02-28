import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/AppNotificationUser.dart';

import '../../../Common/Model/AppMatch/AppMatchUser.dart';
import '../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import '../../../Common/Model/CreditCard/CreditCard.dart';
import '../../../Common/Model/Reward.dart';
import '../../../Common/Model/Sport.dart';
import '../../../Common/Model/User/UserComplete.dart';
import 'package:geolocator/geolocator.dart';

import '../../Features/Authentication/LoadLogin/Repository/LoadLoginRepo.dart';

class UserProvider extends ChangeNotifier {
  UserComplete? _user;
  UserComplete? get user => _user;
  set user(UserComplete? newUser) {
    _user = newUser;
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
        return a.validUntil.compareTo(b.validUntil);
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
}
