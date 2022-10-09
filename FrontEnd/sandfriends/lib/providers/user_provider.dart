import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/match.dart';
import 'package:sandfriends/models/match_counter.dart';
import 'package:sandfriends/providers/categories_provider.dart';
import '../models/match.dart';
import 'package:intl/intl.dart';

import '../models/rank.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  List<Match> _matchList = [];
  List<Match> get matchList {
    _matchList.sort(
      (a, b) {
        int compare = a.day!.compareTo(b.day!);

        if (compare == 0) {
          return a.timeInt.compareTo(b.timeInt);
        } else {
          return compare;
        }
      },
    );
    _matchList.sort(((a, b) => a.day!.compareTo(b.day!)));
    for (int i = 0; i < _matchList.length; i++) {
      print(_matchList[i].day);
    }
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

  void userFromJson(Map<String, dynamic> json, CategoriesProvider categories) {
    var gender;
    var sidePreference;
    for (int i = 0; i < categories.genders.length; i++) {
      if (categories.genders[i].idGender == json['IdGenderCategory']) {
        gender = categories.genders[i];
      }
    }
    for (int i = 0; i < categories.sidePreferences.length; i++) {
      if (categories.sidePreferences[i].idSidePreference ==
          json['IdSidePreferenceCategory']) {
        sidePreference = categories.sidePreferences[i];
      }
    }
    user = User(
      idUser: json['IdUser'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      gender: gender,
      phoneNumber: json['PhoneNumber'],
      birthday: json['Birthday'],
      age: json['Age'],
      height: json['Height'],
      sidePreference: sidePreference,
      photo: json['Photo'],
    );
  }

  void userRankFromJson(List<dynamic> response, CategoriesProvider categories) {
    bool foundUserRank;
    for (int sportsCategories = 0;
        sportsCategories < categories.sports.length;
        sportsCategories++) {
      foundUserRank = false;
      for (int userRank = 0; userRank < response.length; userRank++) {
        for (int rankCategories = 0;
            rankCategories < categories.ranks.length;
            rankCategories++) {
          if ((response[userRank]['IdRankCategory'] ==
                  categories.ranks[rankCategories].idRankCategory) &&
              (categories.ranks[rankCategories].sport.idSport ==
                  categories.sports[sportsCategories].idSport)) {
            foundUserRank = true;

            user!.rank.add(categories.ranks[rankCategories]);
          }
        }
      }
      if (foundUserRank == false) {
        for (int rankCategories = 0;
            rankCategories < categories.ranks.length;
            rankCategories++) {
          if (categories.ranks[rankCategories].sport.idSport ==
                  categories.sports[sportsCategories].idSport &&
              categories.ranks[rankCategories].rankSportLevel == 0) {
            user!.rank.add(Rank(
                idRankCategory: categories.ranks[rankCategories].idRankCategory,
                sport: categories.sports[sportsCategories],
                rankSportLevel: categories.ranks[rankCategories].rankSportLevel,
                name: categories.ranks[rankCategories].name,
                color: categories.ranks[rankCategories].color));
          }
        }
      }
    }
  }

  void userMatchCounterFromJson(
      List<dynamic> response, CategoriesProvider categories) {
    user!.matchCounter.clear();
    for (int sportsCategories = 0;
        sportsCategories < categories.sports.length;
        sportsCategories++) {
      for (int i = 0; i < response.length; i++)
        if (response[i]['idSport'] ==
            categories.sports[sportsCategories].idSport) {
          user!.matchCounter.add(MatchCounter(
              total: response[i]['matchCounter'],
              sport: categories.sports[sportsCategories]));
        }
    }
  }

  int _openMatchesCounter = 0;
  int get openMatchesCounter => _openMatchesCounter;
  set openMatchesCounter(int value) {
    _openMatchesCounter = value;
  }
}
