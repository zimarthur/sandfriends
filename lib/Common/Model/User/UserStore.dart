import 'package:sandfriends/Common/Model/User/User.dart';

import '../Gender.dart';
import '../Rank.dart';
import '../Sport.dart';

class UserStore extends User {
  bool isStorePlayer;
  Rank? rank;

  UserStore({
    required super.firstName,
    required super.lastName,
    super.id,
    super.phoneNumber,
    super.photo,
    super.gender,
    super.preferenceSport,
    this.rank,
    required this.isStorePlayer,
  });

  factory UserStore.fromUserJson(
    Map<String, dynamic> parsedJson,
    List<Sport> availableSports,
    List<Gender> availableGenders,
    List<Rank> availableRanks,
  ) {
    return UserStore(
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
      preferenceSport: availableSports.firstWhere(
        (preferenceSport) => preferenceSport.idSport == parsedJson["IdSport"],
      ),
      rank: availableRanks.firstWhere(
        (rank) => rank.idRankCategory == parsedJson["IdRankCategory"],
      ),
      photo: parsedJson["Photo"],
    );
  }
  factory UserStore.fromStorePlayerJson(
    Map<String, dynamic> parsedJson,
    List<Sport> availableSports,
    List<Gender> availableGenders,
    List<Rank> availableRanks,
  ) {
    return UserStore(
      id: parsedJson["IdStorePlayer"],
      firstName: parsedJson["FirstName"],
      lastName: parsedJson["LastName"],
      phoneNumber: parsedJson["PhoneNumber"],
      gender: availableGenders.firstWhere(
        (gender) => gender.idGender == parsedJson["IdGenderCategory"],
      ),
      isStorePlayer: true,
      preferenceSport: availableSports.firstWhere(
        (preferenceSport) => preferenceSport.idSport == parsedJson["IdSport"],
      ),
      rank: availableRanks.firstWhere(
        (rank) => rank.idRankCategory == parsedJson["IdRankCategory"],
      ),
    );
  }
  factory UserStore.fromUserMinJson(Map<String, dynamic> parsedJson) {
    return UserStore(
        id: parsedJson["IdUser"],
        firstName: parsedJson["UserFirstName"] ?? parsedJson["FirstName"],
        lastName: parsedJson["UserLastName"] ?? parsedJson["LastName"],
        isStorePlayer: false,
        photo: parsedJson["UserPhoto"] ?? parsedJson["Photo"]);
  }

  factory UserStore.copyFrom(UserStore refUserStore) {
    return UserStore(
      id: refUserStore.id,
      firstName: refUserStore.firstName,
      lastName: refUserStore.lastName,
      phoneNumber: refUserStore.phoneNumber,
      gender: refUserStore.gender,
      isStorePlayer: refUserStore.isStorePlayer,
      preferenceSport: refUserStore.preferenceSport,
      rank: refUserStore.rank,
      photo: refUserStore.photo,
    );
  }
}
