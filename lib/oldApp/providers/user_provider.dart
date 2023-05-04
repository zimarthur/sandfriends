import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends/SharedComponents/Model/MatchCounter.dart';
import 'package:sandfriends/SharedComponents/Model/Reward.dart';
import 'package:sandfriends/SharedComponents/Model/Sport.dart';
import 'package:sandfriends/oldApp/providers/categories_provider.dart';
import '../../SharedComponents/Model/AppNotification.dart';
import '../../SharedComponents/Model/AppMatch.dart';

import '../../SharedComponents/Model/User.dart';

class UserProvider with ChangeNotifier {
  void resetUserProvider() {
    user = null;
    clearMatchList();
    _openMatchesCounter = 0;
    _notificationList.clear();
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
  }

  List<AppMatch> get nextMatchList {
    var filteredList = matchList.where((match) {
      if (match.date.isAfter(DateTime.now()) && (match.canceled == false)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    filteredList.sort(
      (a, b) {
        int compare = a.date.compareTo(b.date);

        if (compare == 0) {
          return a.timeInt.compareTo(b.timeInt);
        } else {
          return compare;
        }
      },
    );
    return filteredList;
  }

  final List<AppMatch> _matchList = [];
  List<AppMatch> get matchList {
    List<AppMatch> filteredMatchList;
    filteredMatchList = _matchList.where((match) {
      for (int i = 0; i < match.members.length; i++) {
        if (match.members[i].user.idUser == user!.idUser) {
          if (match.members[i].refused == false &&
              match.members[i].waitingApproval == false &&
              match.members[i].quit == false) {
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
          return b.timeInt.compareTo(a.timeInt);
        } else {
          return compare;
        }
      },
    );
    return filteredMatchList;
  }

  void addMatch(AppMatch newMatch) {
    _matchList.add(newMatch);
  }

  void clearMatchList() {
    _matchList.clear();
  }

  bool _feedNeedsRefresh = true;
  bool get feedNeedsRefresh => _feedNeedsRefresh;
  set feedNeedsRefresh(bool value) {
    _feedNeedsRefresh = value;
  }

  int _indexEditModal = 0;
  int get indexEditModal => _indexEditModal;
  set indexEditModal(int value) {
    _indexEditModal = value;
    notifyListeners();
  }

  void userMatchCounterFromJson(
      List<dynamic> response, CategoriesProvider categories) {
    user!.matchCounter.clear();

    for (int i = 0; i < response.length; i++) {
      user!.matchCounter.add(
        MatchCounter(
          total: response[i]['MatchCounter'],
          sport: Sport(
            idSport: response[i]['Sport']['IdSport'],
            description: response[i]['Sport']['Description'],
            photoUrl: response[i]['Sport']['SportPhoto'],
          ),
        ),
      );
    }
  }

  int _openMatchesCounter = 0;
  int get openMatchesCounter => _openMatchesCounter;
  set openMatchesCounter(int value) {
    _openMatchesCounter = value;
  }

  final List<AppNotification> _notificationList = [];
  List<AppNotification> get notificationList {
    _notificationList.sort(
      (a, b) {
        int compare = b.idNotification.compareTo(a.idNotification);

        if (compare == 0) {
          return b.idNotification.compareTo(a.idNotification);
        } else {
          return compare;
        }
      },
    );
    return _notificationList;
  }

  void clearNotificationList() {
    _notificationList.clear();
  }

  void addNotification(AppNotification notification) {
    _notificationList.add(notification);
  }

  Reward? _userReward;
  Reward? get userReward => _userReward;
  set userReward(Reward? value) {
    _userReward = value;
  }
}
