import '../../../Remote/Url.dart';
import '../Gender.dart';
import '../Rank.dart';
import '../Sport.dart';

class PlayerOld {
  int? id;
  String firstName;
  String lastName;
  bool isStorePlayer;
  String? photo;
  String? phoneNumber;
  Gender? gender;
  Sport? sport;
  Rank? rank;

  String get fullName => "$firstName $lastName";
  PlayerOld({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.isStorePlayer,
    this.phoneNumber,
    this.photo,
    this.gender,
    this.sport,
    this.rank,
  });

  factory PlayerOld.fromUserJson(
    Map<String, dynamic> parsedJson,
    List<Sport> availableSports,
    List<Gender> availableGenders,
    List<Rank> availableRanks,
  ) {
    return PlayerOld(
      id: parsedJson["IdUser"],
      firstName: parsedJson["FirstName"],
      lastName: parsedJson["LastName"],
      phoneNumber: parsedJson["PhoneNumber"],
      gender: parsedJson["IdGenderCategory"] != null
          ? availableGenders.firstWhere(
              (gender) => gender.idGender == parsedJson["IdGenderCategory"],
            )
          : parsedJson["IdGenderCategory"],
      isStorePlayer: false,
      sport: availableSports.firstWhere(
        (sport) => sport.idSport == parsedJson["IdSport"],
      ),
      rank: availableRanks.firstWhere(
        (rank) => rank.idRankCategory == parsedJson["IdRankCategory"],
      ),
      photo: parsedJson["Photo"],
    );
  }
  factory PlayerOld.fromStorePlayerJson(
    Map<String, dynamic> parsedJson,
    List<Sport> availableSports,
    List<Gender> availableGenders,
    List<Rank> availableRanks,
  ) {
    return PlayerOld(
      id: parsedJson["IdStorePlayer"],
      firstName: parsedJson["FirstName"],
      lastName: parsedJson["LastName"],
      phoneNumber: parsedJson["PhoneNumber"],
      gender: availableGenders.firstWhere(
        (gender) => gender.idGender == parsedJson["IdGenderCategory"],
      ),
      isStorePlayer: true,
      sport: availableSports.firstWhere(
        (sport) => sport.idSport == parsedJson["IdSport"],
      ),
      rank: availableRanks.firstWhere(
        (rank) => rank.idRankCategory == parsedJson["IdRankCategory"],
      ),
    );
  }
  factory PlayerOld.fromUserMinJson(Map<String, dynamic> parsedJson) {
    return PlayerOld(
        id: parsedJson["IdUser"],
        firstName: parsedJson["FirstName"],
        lastName: parsedJson["LastName"],
        isStorePlayer: false,
        photo: parsedJson["Photo"]);
  }

  factory PlayerOld.copyFrom(PlayerOld refPlayer) {
    return PlayerOld(
      id: refPlayer.id,
      firstName: refPlayer.firstName,
      lastName: refPlayer.lastName,
      phoneNumber: refPlayer.phoneNumber,
      gender: refPlayer.gender,
      isStorePlayer: refPlayer.isStorePlayer,
      sport: refPlayer.sport,
      rank: refPlayer.rank,
      photo: refPlayer.photo,
    );
  }
}
