import 'package:intl/intl.dart';

import '../../oldApp/models/court.dart';
import '../../oldApp/models/match_member.dart';
import 'Sport.dart';
import 'User.dart';

class AppMatch {
  final int idMatch;
  final DateTime date;
  final int cost;
  final int timeInt;
  final String timeBegin;
  final String timeFinish;
  bool isOpenMatch;
  int maxUsers = 0;
  final bool canceled;
  final String matchUrl;
  String creatorNotes;
  final Court court;
  final Sport sport;
  final String canCancelUpTo;
  List<MatchMember> members = [];

  User get matchCreator =>
      members.firstWhere((member) => member.isMatchCreator == true).user;

  int get remainingSlots {
    int validMembersCounter = 0;
    for (int i = 0; i < members.length; i++) {
      if (members[i].refused == false &&
          members[i].waitingApproval == false &&
          members[i].quit == false) {
        validMembersCounter++;
      }
    }
    return maxUsers - validMembersCounter;
  }

  int get activeMatchMembers {
    int activeMatchMembersCounter = 0;
    for (int i = 0; i < members.length; i++) {
      if (members[i].refused == false &&
          members[i].waitingApproval == false &&
          members[i].quit == false) {
        activeMatchMembersCounter++;
      }
    }
    return activeMatchMembersCounter;
  }

  void increaseMaxUser() {
    maxUsers++;
  }

  void reduceMaxUser() {
    if (maxUsers > 1) {
      maxUsers--;
    }
  }

  AppMatch({
    required this.idMatch,
    required this.date,
    required this.cost,
    required this.timeInt,
    required this.timeBegin,
    required this.timeFinish,
    required this.isOpenMatch,
    required this.maxUsers,
    required this.canceled,
    required this.matchUrl,
    required this.creatorNotes,
    required this.court,
    required this.sport,
    required this.canCancelUpTo,
  });

  factory AppMatch.fromJson(Map<String, dynamic> json) {
    var newMatch = AppMatch(
      idMatch: json['IdMatch'],
      date: DateFormat('yyyy-MM-dd HH:mm')
          .parse("${json['Date']} ${json['TimeBegin']}"),
      cost: json['Cost'],
      timeInt: json['TimeInteger'],
      timeBegin: json['TimeBegin'],
      timeFinish: json['TimeEnd'],
      isOpenMatch: json['OpenUsers'],
      maxUsers: json['MaxUsers'],
      canceled: json['Canceled'],
      matchUrl: json['MatchUrl'],
      creatorNotes: json['CreatorNotes'],
      court: courtFromJson(json['StoreCourt']),
      sport: Sport.fromJson(json['Sport']),
      canCancelUpTo: json['CanCancelUpTo'],
    );
    for (int i = 0; i < json['Members'].length; i++) {
      newMatch.members.add(matchMemberFromJson(json['Members'][i]));
    }
    return newMatch;
  }
}
