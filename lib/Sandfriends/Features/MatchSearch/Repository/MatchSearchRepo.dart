import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class MatchSearchRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> searchCourts(
    BuildContext context,
    String? accessToken,
    int sportId,
    int cityId,
    DateTime dateStart,
    DateTime dateEnd,
    int timeStart,
    int timeEnd,
    int? idStore,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.searchCourts,
      jsonEncode(
        <String, Object?>{
          'AccessToken': accessToken,
          'IdSport': sportId,
          'IdCity': cityId,
          'DateStart': DateFormat("dd-MM-yyyy").format(dateStart),
          'DateEnd': DateFormat("dd-MM-yyyy").format(dateEnd),
          'TimeStart': timeStart,
          'TimeEnd': timeEnd,
          if (idStore != null) 'IdStore': idStore
        },
      ),
    );
    return response;
  }
}
