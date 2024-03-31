import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Model/School/School.dart';
import 'package:sandfriends/Common/Model/Teacher.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class PartnerSchoolsRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> schoolInvitationResponse(
    BuildContext context,
    String accessToken,
    Teacher teacher,
    bool accepted,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.schoolInvitationResponse,
      jsonEncode(
        <String, Object?>{
          'AccessToken': accessToken,
          'IdTeacher': teacher.idTeacher,
          "Accepted": accepted,
        },
      ),
    );
    return response;
  }
}
