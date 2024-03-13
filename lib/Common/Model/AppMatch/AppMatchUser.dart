import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatch.dart';
import 'package:sandfriends/Common/Model/Coupon/CouponUser.dart';

import '../Coupon/Coupon.dart';
import '../Court.dart';
import '../CreditCard/CreditCard.dart';
import '../Hour.dart';
import '../MatchMember.dart';
import '../PaymentStatus.dart';
import '../Rank.dart';
import '../SelectedPayment.dart';
import '../Sport.dart';
import '../User/UserComplete.dart';

class AppMatchUser extends AppMatch {
  double userCost;
  bool isOpenMatch;
  int maxUsers = 0;
  String matchUrl;
  List<MatchMember> members = [];
  String? pixCode;
  CreditCard? creditCard;
  Coupon? coupon;
  AppMatchUser({
    required super.idMatch,
    required super.idRecurrentMatch,
    required super.date,
    required super.cost,
    required super.timeBegin,
    required super.timeEnd,
    required super.canceled,
    required super.creatorNotes,
    required super.court,
    required super.sport,
    required super.selectedPayment,
    required super.paymentStatus,
    required super.paymentExpirationDate,
    required this.coupon,
    required this.userCost,
    required this.isOpenMatch,
    required this.maxUsers,
    required this.matchUrl,
    this.creditCard,
    this.pixCode,
  });

  UserComplete get matchCreator =>
      members.firstWhere((member) => member.isMatchCreator == true).user;

  Rank get matchRank => matchCreator.ranks
      .firstWhere((rank) => rank.sport.idSport == sport.idSport);

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

  bool hasUserSentInvitation(UserComplete user) {
    if (members.any(
      (member) => member.user.id == user.id,
    )) {
      return members
              .firstWhere(
                (member) => member.user.id == user.id,
              )
              .waitingApproval ==
          true;
    }
    return false;
  }

  void increaseMaxUser() {
    maxUsers++;
  }

  void reduceMaxUser() {
    if (maxUsers > 1) {
      maxUsers--;
    }
  }

  factory AppMatchUser.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    Hour timeBegin = referenceHours.firstWhere(
      (hour) => hour.hour == json['TimeBegin'],
    );
    var newMatch = AppMatchUser(
      idMatch: json['IdMatch'],
      date: DateFormat('dd/MM/yyyy HH:mm')
          .parse("${json['Date']} ${timeBegin.hourString}"),
      cost: double.parse(
        json['Cost'],
      ),
      userCost: double.parse(
        json['CostUser'],
      ),
      timeBegin: timeBegin,
      timeEnd: referenceHours.firstWhere(
        (hour) => hour.hour == json['TimeEnd'],
      ),
      isOpenMatch: json['OpenUsers'],
      maxUsers: json['MaxUsers'],
      canceled: json['Canceled'],
      matchUrl: json['MatchUrl'],
      creatorNotes: json['CreatorNotes'],
      court: Court.fromJsonMatch(json['StoreCourt']),
      sport: referenceSports.firstWhere(
        (sport) => sport.idSport == json['IdSport'],
      ),
      paymentStatus: decoderPaymentStatus(json['PaymentStatus']),
      selectedPayment: decoderSelectedPayment(json['PaymentType']),
      pixCode: json['PixCode'],
      creditCard: json['CreditCard'] == null
          ? null
          : CreditCard.fromJson(json['CreditCard']),
      paymentExpirationDate: DateFormat('yyyy-MM-dd HH:mm:ss')
          .parse(json['PaymentExpirationDate']),
      idRecurrentMatch: json['IdRecurrentMatch'],
      coupon: json['Coupon'] != null
          ? CouponUser.fromJson(
              json['Coupon'],
            )
          : null,
    );
    for (int i = 0; i < json['Members'].length; i++) {
      newMatch.members.add(
        MatchMember.fromJson(
          json['Members'][i],
        ),
      );
    }
    return newMatch;
  }
}
