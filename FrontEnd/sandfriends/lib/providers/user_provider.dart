import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/city.dart';
import 'package:sandfriends/models/gender.dart';
import 'package:sandfriends/models/match.dart';
import 'package:sandfriends/models/match_counter.dart';
import 'package:sandfriends/models/region.dart';
import 'package:sandfriends/models/side_preference.dart';
import 'package:sandfriends/models/sport.dart';
import 'package:sandfriends/providers/categories_provider.dart';
import '../models/match.dart';
import 'package:intl/intl.dart';

import '../models/notification_sf.dart';
import '../models/rank.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
  }

  List<Match> get nextMatchList {
    var filteredList = matchList.where((match) {
      if ((match.date.isAfter(DateTime.now()) ||
              (match.date == DateTime.now() &&
                  match.timeInt > DateTime.now().hour)) &&
          (match.canceled == false)) {
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

  List<Match> _matchList = [];
  List<Match> get matchList {
    _matchList.sort(
      (a, b) {
        int compare = b.date.compareTo(a.date);

        if (compare == 0) {
          return b.timeInt.compareTo(a.timeInt);
        } else {
          return compare;
        }
      },
    );
    return _matchList;
  }

  void addMatch(Match newMatch) {
    _matchList.add(newMatch);
  }

  void clearMatchList() {
    _matchList.clear();
  }

  bool _nextMatchNeedsRefresh = false;
  bool get nextMatchNeedsRefresh => _nextMatchNeedsRefresh;
  set nextMatchNeedsRefresh(bool value) {
    _nextMatchNeedsRefresh = value;
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

  List<NotificationSF> _notificationList = [];
  List<NotificationSF> get notificationList {
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

  void addNotification(NotificationSF notification) {
    _notificationList.add(notification);
  }
}
