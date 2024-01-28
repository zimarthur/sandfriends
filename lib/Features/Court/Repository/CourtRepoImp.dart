import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'CourtRepo.dart';

class CourtRepoImp implements CourtRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getStore(
    BuildContext context,
    String idStore,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      "${Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().getStore,
      )}/$idStore",
    );

    return response;
  }
}
