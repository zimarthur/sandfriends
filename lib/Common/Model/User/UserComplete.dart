import 'package:intl/intl.dart';

import '../../Utils/SFDateTime.dart';
import '../City.dart';
import '../Gender.dart';
import '../MatchCounter.dart';
import '../Rank.dart';
import '../SidePreference.dart';
import '../Sport.dart';
import 'User.dart';

class UserComplete extends User {
  String accessToken;
  DateTime? birthday;
  double? height;
  SidePreference? sidePreference;
  List<Rank> ranks = [];
  List<MatchCounter> matchCounter = [];
  String email;
  City? city;
  String? cpf;
  bool allowNotifications;
  String? notificationsToken;
  bool allowNotificationsOpenMatches;
  bool allowNotificationsCoupons;

  UserComplete({
    required super.firstName,
    required super.lastName,
    super.id,
    super.phoneNumber,
    super.photo,
    super.gender,
    super.preferenceSport,
    required this.email,
    required this.accessToken,
    this.birthday,
    this.height,
    this.sidePreference,
    this.city,
    this.cpf,
    this.allowNotifications = false,
    this.notificationsToken,
    this.allowNotificationsOpenMatches = false,
    this.allowNotificationsCoupons = false,
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

  factory UserComplete.fromJson(Map<String, dynamic> json) {
    var newUser = UserComplete(
      id: json['IdUser'],
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
      allowNotifications: json['AllowNotifications'] ?? false,
      notificationsToken: json['NotificationsToken'],
      allowNotificationsOpenMatches:
          json['AllowNotificationsOpenMatches'] ?? false,
      allowNotificationsCoupons: json['AllowNotificationsCoupons'] ?? false,
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
        "idUser": id,
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

  factory UserComplete.copyWith(UserComplete refUser) {
    final user = UserComplete(
      email: refUser.email,
      accessToken: refUser.accessToken,
      firstName: refUser.firstName,
      lastName: refUser.lastName,
      birthday: refUser.birthday,
      city: refUser.city,
      gender: refUser.gender,
      height: refUser.height,
      id: refUser.id,
      phoneNumber: refUser.phoneNumber,
      photo: refUser.photo,
      preferenceSport: refUser.preferenceSport,
      sidePreference: refUser.sidePreference,
      cpf: refUser.cpf,
      allowNotifications: refUser.allowNotifications,
      notificationsToken: refUser.notificationsToken,
      allowNotificationsCoupons: refUser.allowNotificationsCoupons,
      allowNotificationsOpenMatches: refUser.allowNotificationsOpenMatches,
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
