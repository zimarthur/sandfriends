import 'package:intl/intl.dart';
import 'package:sandfriends/Remote/Url.dart';
import 'package:sandfriends/SharedComponents/Model/City.dart';
import 'package:sandfriends/SharedComponents/Model/MatchCounter.dart';
import 'package:sandfriends/Utils/SFDateTime.dart';

import 'Rank.dart';
import 'SidePreference.dart';
import 'Gender.dart';
import 'Sport.dart';

class User {
  int? idUser;
  String accessToken;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  Gender? gender;
  DateTime? birthday;
  double? height;
  SidePreference? sidePreference;
  dynamic photo;
  List<Rank> ranks = [];
  List<MatchCounter> matchCounter = [];
  String email;
  City? city;
  Sport? preferenceSport;

  User({
    required this.email,
    required this.accessToken,
    this.idUser,
    this.firstName,
    this.lastName,
    this.photo,
    this.phoneNumber,
    this.gender,
    this.birthday,
    this.height,
    this.sidePreference,
    this.city,
    this.preferenceSport,
  });

  int? get age {
    if (birthday == null) return null;

    DateTime today = DateTime.now();
    int differenceInYears = today.year - birthday!.year;

    if (today.month < birthday!.month ||
        (today.month == birthday!.month && today.day < birthday!.day)) {
      differenceInYears--;
    }
    return differenceInYears;
  }

  int getUserTotalMatches() {
    return matchCounter
        .map(
          (e) => e.total,
        )
        .reduce((value, current) => value + current);
  }

  int getUserSportMatches(Sport selectedSport) {
    return matchCounter
        .firstWhere((element) => element.sport.idSport == selectedSport.idSport)
        .total;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    var newUser = User(
      idUser: json['IdUser'],
      accessToken: json['AccessToken'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      birthday:
          json['Birthday'] == null ? null : stringToDateTime(json['Birthday']),
      email: json['Email'],
      gender: json['GenderCategory'] == null
          ? null
          : Gender.fromJson(json['GenderCategory']),
      phoneNumber: json['PhoneNumber'],
      preferenceSport:
          json['Sport'] == null ? null : Sport.fromJson(json['Sport']),
      city: json['City'] == null ? null : City.fromJsonUser(json['City']),
      sidePreference: json['SidePreferenceCategory'] == null
          ? null
          : SidePreference.fromJson(json['SidePreferenceCategory']),
      photo:
          json['Photo'] != null ? sandfriendsRequestsUrl + json['Photo'] : null,
    );
    for (int i = 0; i < json['Ranks'].length; i++) {
      newUser.ranks.add(Rank.fromJson(json['Ranks'][i]['RankCategory']));
    }
    return newUser;
  }

  Map<String, Object> toJson() {
    List<Map<String, dynamic>> rankJson = [];
    for (var rank in ranks) {
      rankJson.add({
        "idUser": idUser,
        "idRankCategory": rank.idRankCategory,
        "idSport": rank.sport.idSport
      });
    }
    return <String, Object>{
      'AccessToken': accessToken,
      'FirstName': firstName!,
      'LastName': lastName!,
      'PhoneNumber': phoneNumber!,
      'IdGender': gender == null ? "" : gender!.idGender,
      'Birthday':
          birthday == null ? "" : DateFormat("yyyy-MM-dd").format(birthday!),
      'Height': height ?? "",
      'SidePreference':
          sidePreference == null ? "" : sidePreference!.idSidePreference,
      'Rank': rankJson,
      'IdCity': city!.cityId,
      'IdSport': preferenceSport!.idSport,
      'Photo': photo ?? "",
    };
  }

  void matchCounterFromJson(List<dynamic> response) {
    matchCounter.clear();

    for (int i = 0; i < response.length; i++) {
      matchCounter.add(
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

  factory User.copyWith(User refUser) {
    final user = User(
      email: refUser.email,
      accessToken: refUser.accessToken,
      firstName: refUser.firstName,
      lastName: refUser.lastName,
      birthday: refUser.birthday,
      city: refUser.city,
      gender: refUser.gender,
      height: refUser.height,
      idUser: refUser.idUser,
      phoneNumber: refUser.phoneNumber,
      photo: refUser.photo,
      preferenceSport: refUser.preferenceSport,
      sidePreference: refUser.sidePreference,
    );
    for (var rank in refUser.ranks) {
      user.ranks.add(
        Rank.CopyWith(
          rank,
        ),
      );
    }
    for (var matchCounter in refUser.matchCounter) {
      user.matchCounter.add(matchCounter);
    }
    return user;
  }
}
