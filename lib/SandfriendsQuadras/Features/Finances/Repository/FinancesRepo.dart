import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class FinancesRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> searchCustomMatches(
    BuildContext context,
    String accessToken,
    DateTime startDate,
    DateTime? endDate,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.searchCustomMatches,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "DateStart": DateFormat("dd/MM/yyyy").format(startDate),
          "DateEnd": endDate == null
              ? DateFormat("dd/MM/yyyy").format(startDate)
              : DateFormat("dd/MM/yyyy").format(endDate),
        },
      ),
    );
    return response;
  }
}
