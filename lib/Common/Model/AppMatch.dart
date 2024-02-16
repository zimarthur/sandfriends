import 'package:intl/intl.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/Model/Coupon.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';

import 'Court.dart';
import 'Hour.dart';
import 'MatchMember.dart';
import 'PaymentStatus.dart';
import 'Rank.dart';
import 'Sport.dart';
import 'User.dart';

class AppMatch {
  int idMatch;
  int idRecurrentMatch;
  DateTime date;
  double rawCost;
  double cost;
  Hour timeBegin;
  Hour timeEnd;
  bool isOpenMatch;
  int maxUsers = 0;
  bool canceled;
  String matchUrl;
  String creatorNotes;
  Court court;
  Sport sport;
  List<MatchMember> members = [];
  SelectedPayment selectedPayment;
  PaymentStatus paymentStatus;
  String? pixCode;
  CreditCard? creditCard;
  DateTime paymentExpirationDate;
  Coupon? coupon;

  User get matchCreator =>
      members.firstWhere((member) => member.isMatchCreator == true).user;

  Rank get matchRank => matchCreator.ranks
      .firstWhere((rank) => rank.sport.idSport == sport.idSport);

  bool get isPaymentExpired {
    return DateTime.now().isAfter(paymentExpirationDate) &&
        paymentStatus == PaymentStatus.Pending;
  }

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

  bool hasUserSentInvitation(User user) {
    if (members.any(
      (member) => member.user.idUser == user.idUser,
    )) {
      return members
              .firstWhere(
                (member) => member.user.idUser == user.idUser,
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

  bool isFromRecurrentMatch() {
    return idRecurrentMatch != 0;
  }

  AppMatch({
    required this.idMatch,
    required this.date,
    required this.cost,
    required this.rawCost,
    required this.timeBegin,
    required this.timeEnd,
    required this.isOpenMatch,
    required this.maxUsers,
    required this.canceled,
    required this.matchUrl,
    required this.creatorNotes,
    required this.court,
    required this.sport,
    required this.paymentStatus,
    required this.selectedPayment,
    required this.pixCode,
    required this.creditCard,
    required this.paymentExpirationDate,
    required this.idRecurrentMatch,
    this.coupon,
  });

  factory AppMatch.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    Hour timeBegin = referenceHours.firstWhere(
      (hour) => hour.hour == json['TimeBegin'],
    );
    var newMatch = AppMatch(
      idMatch: json['IdMatch'],
      date: DateFormat('yyyy-MM-dd HH:mm')
          .parse("${json['Date']} ${timeBegin.hourString}"),
      cost: double.parse(
        json['CostUser'],
      ),
      rawCost: double.parse(
        json['Cost'],
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
      coupon: json['Coupon'] != null ? Coupon.fromJson(json['Coupon']) : null,
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
