import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/TeamMember.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class TeamRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> joinTeam(
    BuildContext context,
    String accessToken,
    Team team,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.joinTeam,
      jsonEncode(
        <String, Object?>{
          'AccessToken': accessToken,
          'IdTeam': team.idTeam,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> sendMemberResponse(
    BuildContext context,
    String accessToken,
    TeamMember member,
    bool accepted,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.sendMemberResponse,
      jsonEncode(
        <String, Object?>{
          'AccessToken': accessToken,
          'IdTeamMember': member.idTeamMember,
          "Accepted": accepted,
        },
      ),
    );
    return response;
  }
}
