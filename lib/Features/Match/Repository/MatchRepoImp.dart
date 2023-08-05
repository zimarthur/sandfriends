import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'MatchRepo.dart';

class MatchRepoImp implements MatchRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getMatchInfo(
    BuildContext context,
    String matchUrl,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().getMatchInfo,
      ),
      jsonEncode(
        <String, Object>{
          "MatchUrl": matchUrl,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> saveCreatorNotes(
    BuildContext context,
    String accessToken,
    int idMatch,
    String newCreatorNotes,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().saveCreatorNotes,
      ),
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

  @override
  Future<NetworkResponse> invitationResponse(
    BuildContext context,
    String accessToken,
    int idMatch,
    int idUser,
    bool accepted,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().invitationResponse,
      ),
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

  @override
  Future<NetworkResponse> removeMatchMember(
    BuildContext context,
    String accessToken,
    int idMatch,
    int idUser,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().removeMatchMember,
      ),
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

  @override
  Future<NetworkResponse> cancelMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().cancelMatch,
      ),
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> leaveMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().leaveMatch,
      ),
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> joinMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().joinMatch,
      ),
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> saveOpenMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
    bool isOpenMatch,
    int maxUsers,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().saveOpenMatch,
      ),
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
