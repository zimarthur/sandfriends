import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class RecurrentMatchSearchRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> searchRecurrentCourts(
    BuildContext context,
    String accessToken,
    int sportId,
    int cityId,
    String days,
    String timeStart,
    String timeEnd,
    int? idStore,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.searchRecurrentCourts,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'IdSport': sportId,
          'IdCity': cityId,
          'Days': days,
          'TimeStart': timeStart,
          'TimeEnd': timeEnd,
          if (idStore != null) 'IdStore': idStore
        },
      ),
    );
    return response;
  }
}
