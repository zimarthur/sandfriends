import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';

import '../../Model/AppMatch.dart';
import '../../Model/AppNotification.dart';
import '../../Model/AppRecurrentMatch.dart';
import '../../Model/Reward.dart';
import '../../Model/User.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  final List<AppMatch> _matches = [];
  List<AppMatch> get matches {
    List<AppMatch> filteredMatchList;
    filteredMatchList = _matches.where((match) {
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

  void clearMatches() {
    _matches.clear();
    notifyListeners();
  }

  void addMatch(AppMatch newMatch) {
    _matches.add(newMatch);
    notifyListeners();
  }

  List<AppMatch> get nextMatches {
    var filteredList = matches.where((match) {
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

  List<AppRecurrentMatch> _recurrentMatches = [
    // AppRecurrentMatch(
    //   idRecurrentMatch: 1,
    //   creationDate: DateFormat('yyyy-MM-dd').parse("2023-05-01"),
    //   lastPaymentDate: DateFormat('yyyy-MM-dd').parse("2023-05-01"),
    //   weekday: 2,
    //   timeBegin: "10:00",
    //   timeEnd: "11:00",
    //   court: Court(
    //     idStoreCourt: 1,
    //     storeCourtName: "quadra 1",
    //     isIndoor: true,
    //   ),
    //   recurrentMatchesCounter: 50,
    // )
  ];
  List<AppRecurrentMatch> get recurrentMatches => _recurrentMatches;

  int _openMatchesCounter = 0;
  int get openMatchesCounter => _openMatchesCounter;
  set openMatchesCounter(int value) {
    _openMatchesCounter = value;
  }

  Reward? _userReward;
  Reward? get userReward => _userReward;
  set userReward(Reward? value) {
    _userReward = value;
  }

  final List<AppNotification> _notifications = [];
  List<AppNotification> get notifications {
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

  void addNotifications(AppNotification newNotification) {
    _notifications.add(newNotification);
    notifyListeners();
  }

  void clear() {
    _matches.clear();
    _notifications.clear();
    _openMatchesCounter = 0;
    _userReward = null;
    notifyListeners();
  }
}
