import 'package:flutter/material.dart';
import 'package:sandfriends/models/match_counter.dart';
import 'package:sandfriends/models/region.dart';

import 'rank.dart';
import 'side_preference.dart';
import 'gender.dart';
import 'sport.dart';

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
  String? email;
  Region? region;
  Sport? preferenceSport;

  User({
    required this.idUser,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.gender,
    this.birthday,
    this.age,
    this.height,
    this.sidePreference,
    this.email,
    this.region,
    required this.photo,
  });
}
