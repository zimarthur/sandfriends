import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import '../../../../Common/Model/User/UserStore.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class ClassesRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> addSchool(
    BuildContext context,
    String accessToken,
    School newSchool,
    String? logo,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addSchool,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "Name": newSchool.name,
          "IdSport": newSchool.sport.idSport,
          if (logo != null) "Logo": logo,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> editSchool(
    BuildContext context,
    String accessToken,
    School editSchool,
    String? logo,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.editSchool,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreSchool": editSchool.idSchool,
          "Name": editSchool.name,
          if (logo != null) "Logo": logo,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> addSchoolTeacher(
    BuildContext context,
    String accessToken,
    School school,
    String teacherEmail,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addSchoolTeacher,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreSchool": school.idSchool,
          "TeacherEmail": teacherEmail,
        },
      ),
    );
    return response;
  }
}
