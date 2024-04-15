import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class CreateTeamRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> addTeam(
    BuildContext context,
    String accessToken,
    Team team,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addTeam,
      jsonEncode(
        <String, Object?>{
          'AccessToken': accessToken,
          'Name': team.name,
          'Description': team.description,
          'IdSport': team.sport.idSport,
          'IdRank': team.rank?.idRankCategory,
          'IdGender': team.gender.idGender,
        },
      ),
    );
    return response;
  }
}
