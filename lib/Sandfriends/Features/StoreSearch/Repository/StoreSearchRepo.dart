import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class StoreSearchRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> searchStores(
    BuildContext context,
    int sportId,
    int cityId,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.searchStores,
      jsonEncode(
        <String, Object>{
          'IdSport': sportId,
          'IdCity': cityId,
        },
      ),
    );
    return response;
  }
}
