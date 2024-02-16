import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class EmployeeInfoRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> addEmployee(
      BuildContext context, String accessToken, String employeeEmail) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addEmployee,
      jsonEncode(<String, Object>{
        "AccessToken": accessToken,
        "Email": employeeEmail,
      }),
    );
    return response;
  }

  Future<NetworkResponse> changeEmployeeAdmin(
    BuildContext context,
    String accessToken,
    int employeeId,
    bool isAdmin,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.changeEmployeeAdmin,
      jsonEncode(<String, Object>{
        "AccessToken": accessToken,
        "IdEmployee": employeeId,
        "IsAdmin": isAdmin,
      }),
    );
    return response;
  }

  Future<NetworkResponse> renameEmployee(
    BuildContext context,
    String accessToken,
    String firstName,
    String lastName,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.renameEmployee,
      jsonEncode(<String, Object>{
        "AccessToken": accessToken,
        "FirstName": firstName,
        "LastName": lastName,
      }),
    );
    return response;
  }

  Future<NetworkResponse> removeEmployee(
    BuildContext context,
    String accessToken,
    int idEmployee,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.removeEmployee,
      jsonEncode(<String, Object>{
        "AccessToken": accessToken,
        "IdEmployee": idEmployee,
      }),
    );
    return response;
  }
}
