import 'dart:convert';

import 'package:sandfriends/SharedComponents/Model/City.dart';
import 'package:sandfriends/SharedComponents/Model/MatchCounter.dart';

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
  String? birthday;
  int? age;
  double? height;
  SidePreference? sidePreference;
  String? photo;
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
    this.age,
    this.height,
    this.sidePreference,
    this.city,
    this.preferenceSport,
  });

  int getUserTotalMatches() {
    return matchCounter
        .map(
          (e) => e.total,
        )
        .reduce((value, current) => value + current);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    var newUser = User(
      idUser: json['IdUser'],
      accessToken: json['AccessToken'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      age: json['Age'],
      birthday: json['Birthday'],
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
          : SidePreference.fromJson(json['SidePreferenceCategory'][0]),
      photo: json['Photo'],
    );
    for (int i = 0; i < json['Ranks'].length; i++) {
      newUser.ranks.add(Rank.fromJson(json['Ranks'][i]));
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
      'Birthday': birthday == null ? "" : birthday!,
      'Height': height ?? "",
      'SidePreference':
          sidePreference == null ? "" : sidePreference!.idSidePreference,
      'Rank': rankJson,
      'IdCity': city!.cityId,
      'IdSport': preferenceSport!.idSport,
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
}
