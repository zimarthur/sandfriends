// import 'package:flutter/material.dart';

// import '../Model/Reward.dart';
// import '../Model/Sport.dart';
// import '../Model/Gender.dart';
// import '../Model/Rank.dart';
// import '../Model/SidePreference.dart';
// import '../Model/AppNotification.dart';
// import '../Model/AppMatch.dart';
// import '../Model/Region.dart';
// import '../Model/User.dart';

// class DataProvider extends ChangeNotifier {
//   // List<Sport> sports = [];
//   // List<Gender> genders = [];
//   // List<Rank> ranks = [];
//   // List<SidePreference> sidePreferences = [];

//   // List<Region> regions = [];

//   User? _user;
//   User? get user => _user;
//   set user(User? newUser) {
//     _user = newUser;
//     notifyListeners();
//   }

//   final List<AppMatch> _matches = [];
//   List<AppMatch> get matches {
//     List<AppMatch> filteredMatchList;
//     filteredMatchList = _matches.where((match) {
//       for (int i = 0; i < match.members.length; i++) {
//         if (match.members[i].user.idUser == user!.idUser) {
//           if (match.members[i].refused == false &&
//               match.members[i].waitingApproval == false &&
//               match.members[i].quit == false) {
//             return true;
//           }
//         }
//       }
//       return false;
//     }).toList();
//     filteredMatchList.sort(
//       (a, b) {
//         int compare = b.date.compareTo(a.date);

//         if (compare == 0) {
//           return b.timeInt.compareTo(a.timeInt);
//         } else {
//           return compare;
//         }
//       },
//     );
//     return filteredMatchList;
//   }

//   void clearMatches() {
//     _matches.clear();
//     notifyListeners();
//   }

//   void addMatch(AppMatch newMatch) {
//     _matches.add(newMatch);
//     notifyListeners();
//   }

//   List<AppMatch> get nextMatches {
//     var filteredList = matches.where((match) {
//       if (match.date.isAfter(DateTime.now()) && (match.canceled == false)) {
//         return true;
//       } else {
//         return false;
//       }
//     }).toList();
//     filteredList.sort(
//       (a, b) {
//         int compare = a.date.compareTo(b.date);

//         if (compare == 0) {
//           return a.timeInt.compareTo(b.timeInt);
//         } else {
//           return compare;
//         }
//       },
//     );
//     return filteredList;
//   }

//   int _openMatchesCounter = 0;
//   int get openMatchesCounter => _openMatchesCounter;
//   set openMatchesCounter(int value) {
//     _openMatchesCounter = value;
//   }

//   Reward? _userReward;
//   Reward? get userReward => _userReward;
//   set userReward(Reward? value) {
//     _userReward = value;
//   }

//   final List<AppNotification> _notifications = [];
//   List<AppNotification> get notifications {
//     _notifications.sort(
//       (a, b) {
//         int compare = b.idNotification.compareTo(a.idNotification);

//         if (compare == 0) {
//           return b.idNotification.compareTo(a.idNotification);
//         } else {
//           return compare;
//         }
//       },
//     );
//     return _notifications;
//   }

//   void clearNotifications() {
//     _notifications.clear();
//     notifyListeners();
//   }

//   void addNotifications(AppNotification newNotification) {
//     _notifications.add(newNotification);
//     notifyListeners();
//   }

//   // void clearAll() {
//   //   _user = null;
//   //   clearUserStats();
//   //   genders.clear();
//   //   ranks.clear();
//   //   sidePreferences.clear();
//   //   sports.clear();
//   //   regions.clear();
//   // }

//   void clearUserStats() {
//     _matches.clear();
//     _notifications.clear();
//     _openMatchesCounter = 0;
//   }
// }
