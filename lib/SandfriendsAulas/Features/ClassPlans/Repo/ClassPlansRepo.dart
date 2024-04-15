import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class ClassPlansRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> addClassPlan(
    BuildContext context,
    String accessToken,
    ClassPlan classPlan,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addClassPlan,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'TimesPerWeek': classPlan.classFrequency.value,
          'ClassSize': classPlan.format.value,
          'Price': classPlan.price,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> deleteClassPlan(
    BuildContext context,
    String accessToken,
    ClassPlan classPlan,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.deleteClassPlan,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'IdClassPlan': classPlan.idClassPlan!,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> editClassPlan(
    BuildContext context,
    String accessToken,
    ClassPlan classPlan,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.editClassPlan,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'IdClassPlan': classPlan.idClassPlan!,
          'Price': classPlan.price,
        },
      ),
    );
    return response;
  }
}
