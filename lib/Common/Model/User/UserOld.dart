import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/City.dart';
import 'package:sandfriends/Common/Model/MatchCounter.dart';

import '../../Utils/SFDateTime.dart';
import '../Rank.dart';
import '../SidePreference.dart';
import '../Gender.dart';
import '../Sport.dart';

class UserOld {
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
  String? cpf;

  UserOld({
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
    this.cpf,
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

  factory UserOld.fromJson(Map<String, dynamic> json) {
    var newUser = UserOld(
      idUser: json['IdUser'],
      accessToken: json['AccessToken'] ?? "",
      firstName: json['FirstName'],
      lastName: json['LastName'],
      height: json['Height'],
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
      photo: json['Photo'],
      cpf: json['Cpf'],
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
      'PhoneNumber': phoneNumber == null
          ? ""
          : phoneNumber!.replaceAll(
              RegExp('[^0-9]'),
              '',
            ),
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

  factory UserOld.copyWith(UserOld refUser) {
    final user = UserOld(
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
      cpf: refUser.cpf,
    );
    for (var rank in refUser.ranks) {
      user.ranks.add(
        Rank.copyWith(
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
