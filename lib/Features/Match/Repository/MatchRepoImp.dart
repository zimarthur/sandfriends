import 'dart:convert';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'MatchRepo.dart';

class MatchRepoImp implements MatchRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getMatchInfo(
    String matchUrl,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().getMatchInfo,
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
    String accessToken,
    int idMatch,
    String newCreatorNotes,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().saveCreatorNotes,
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
    String accessToken,
    int idMatch,
    int idUser,
    bool accepted,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().invitationResponse,
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
    String accessToken,
    int idMatch,
    int idUser,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().removeMatchMember,
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
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().cancelMatch,
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
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().leaveMatch,
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
    String accessToken,
    int idMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().joinMatch,
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
    String accessToken,
    int idMatch,
    bool isOpenMatch,
    int maxUsers,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().saveOpenMatch,
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
