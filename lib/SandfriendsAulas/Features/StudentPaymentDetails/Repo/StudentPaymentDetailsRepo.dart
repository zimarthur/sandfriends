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

class StudentPaymentDetailsRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> updateClassPaymentDetails(
    BuildContext context,
    String accessToken,
    int idMatchMember,
    bool hasPaid,
    double cost,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.updateClassPaymentDetails,
      jsonEncode(
        <String, Object?>{
          'AccessToken': accessToken,
          'IdMatchMember': idMatchMember,
          'HasPaid': hasPaid,
          'Cost': cost,
        },
      ),
    );
    return response;
  }
}
