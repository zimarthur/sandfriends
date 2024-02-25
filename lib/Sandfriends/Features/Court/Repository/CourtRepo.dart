import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class CourtRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getStore(
    BuildContext context,
    String idStore,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      context,
      "${ApiEndPoints.getStore}/$idStore",
    );

    return response;
  }
}
