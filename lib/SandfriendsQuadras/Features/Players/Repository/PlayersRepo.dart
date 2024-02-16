import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import 'package:provider/provider.dart';
import '../../../../Remote/NetworkResponse.dart';

class PlayersRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> addPlayer(
      BuildContext context, String accessToken, Player player) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addStorePlayer,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "FirstName": player.firstName,
          "LastName": player.lastName,
          "PhoneNumber": player.phoneNumber ?? "",
          "IdGenderCategory": player.gender!.idGender,
          "IdSport": player.sport!.idSport,
          "IdRankCategory": player.rank!.idRankCategory,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> editPlayer(
      BuildContext context, String accessToken, Player player) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.editStorePlayer,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStorePlayer": player.id!,
          "FirstName": player.firstName,
          "LastName": player.lastName,
          "PhoneNumber": player.phoneNumber ?? "",
          "IdGenderCategory": player.gender!.idGender,
          "IdSport": player.sport!.idSport,
          "IdRankCategory": player.rank!.idRankCategory,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> deleteStorePlayer(
      BuildContext context, String accessToken, int idStorePlayer) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.deleteStorePlayer,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStorePlayer": idStorePlayer,
        },
      ),
    );
    return response;
  }
}
