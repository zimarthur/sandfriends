import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class MatchRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getMatchInfo(
    BuildContext context,
    String matchUrl,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getMatchInfo,
      jsonEncode(
        <String, Object>{
          "MatchUrl": matchUrl,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> saveCreatorNotes(
    BuildContext context,
    String accessToken,
    int idMatch,
    String newCreatorNotes,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.saveCreatorNotes,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
          "NewCreatorNotes": newCreatorNotes,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> invitationResponse(
    BuildContext context,
    String accessToken,
    int idMatch,
    int idUser,
    bool accepted,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.invitationResponse,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
          "IdUser": idUser,
          "Accepted": accepted,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> removeMatchMember(
    BuildContext context,
    String accessToken,
    int idMatch,
    int idUser,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.removeMatchMember,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
          "IdUser": idUser,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> cancelMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.cancelMatchUser,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> leaveMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.leaveMatch,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> joinMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.joinMatch,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> saveOpenMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
    bool isOpenMatch,
    int maxUsers,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.saveOpenMatch,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
          "IsOpenMatch": isOpenMatch,
          "MaxUsers": maxUsers,
        },
      ),
    );
    return response;
  }
}
