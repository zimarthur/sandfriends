import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../RedirectProvider/EnvironmentProvider.dart';
import 'CategoriesProviderRepo.dart';

class CategoriesProviderRepoImp implements CategoriesProviderRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getAllCities(
    BuildContext context,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().getAllCities,
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> getAvailableRegions(
    BuildContext context,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().getAvailableCities,
      ),
    );
    return response;
  }
}
