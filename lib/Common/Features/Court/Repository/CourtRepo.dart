import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class CourtRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getStore(
    BuildContext context,
    String storeUrl,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      context,
      "${ApiEndPoints.getStore}/$storeUrl",
    );

    return response;
  }

  Future<NetworkResponse> getStoreOperationDays(
    BuildContext context,
    int idStore,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      context,
      "${ApiEndPoints.getStoreOperationDays}/$idStore",
    );

    return response;
  }
}
