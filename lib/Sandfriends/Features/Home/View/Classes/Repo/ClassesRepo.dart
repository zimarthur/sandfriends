import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/School/School.dart';

import '../../../../../../Remote/ApiEndPoints.dart';
import '../../../../../../Remote/NetworkApiService.dart';
import '../../../../../../Remote/NetworkResponse.dart';

class ClassesRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getClassesInfo(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getClassesInfo,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
        },
      ),
    );
    return response;
  }
}
