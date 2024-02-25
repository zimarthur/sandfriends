import '../Gender.dart';
import '../Rank.dart';
import '../Sport.dart';

abstract class User {
  int? id;
  String? firstName;
  String? lastName;
  String? photo;
  String? phoneNumber;
  Gender? gender;
  Sport? preferenceSport;

  String get fullName => "$firstName $lastName";
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.photo,
    this.gender,
    this.preferenceSport,
  });
}
