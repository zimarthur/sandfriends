import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class ClassesRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> searchClasses(
    BuildContext context,
    String accessToken,
    DateTime date,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.searchClasses,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'Date': DateFormat("dd/MM/yyyy").format(date),
        },
      ),
    );
    return response;
  }
}
