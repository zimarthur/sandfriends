import 'package:sandfriends/SharedComponents/Model/City.dart';
import 'package:sandfriends/oldApp/models/match_counter.dart';

import 'Rank.dart';
import 'SidePreference.dart';
import 'Gender.dart';
import 'Sport.dart';

class User {
  int? idUser;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  Gender? gender;
  String? birthday;
  int? age;
  double? height;
  SidePreference? sidePreference;
  String? photo;
  List<Rank> rank = [];
  List<MatchCounter> matchCounter = [];
  String email;
  City? city;
  Sport? preferenceSport;

  User({
    required this.email,
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
  factory User.fromJson(Map<String, dynamic> json) {
    var newUser = User(
      idUser: json['IdUser'],
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
      city: json['City'] == null ? null : City.fromJson(json['City']),
      sidePreference: json['SidePreferenceCategory'] == null
          ? null
          : SidePreference.fromJson(json['SidePreferenceCategory'][0]),
      photo: json['Photo'],
    );
    for (int i = 0; i < json['Ranks'].length; i++) {
      newUser.rank.add(Rank.fromJson(json['Ranks'][i]));
    }
    return newUser;
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
