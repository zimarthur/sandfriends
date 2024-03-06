import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class CategoriesProviderRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getAllCities(
    BuildContext context,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      context,
      ApiEndPoints.getAllCities,
    );
    return response;
  }

  Future<NetworkResponse> getAvailableRegions(
    BuildContext context,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      context,
      ApiEndPoints.getAvailableCities,
    );
    return response;
  }
}
