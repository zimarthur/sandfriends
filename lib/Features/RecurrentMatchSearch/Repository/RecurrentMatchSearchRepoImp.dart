import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'RecurrentMatchSearchRepo.dart';

class RecurrentMatchSearchRepoImp implements RecurrentMatchSearchRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> searchRecurrentCourts(
    BuildContext context,
    String accessToken,
    int sportId,
    int cityId,
    String days,
    String timeStart,
    String timeEnd,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().searchRecurrentCourts,
      ),
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'IdSport': sportId,
          'IdCity': cityId,
          'Days': days,
          'TimeStart': timeStart,
          'TimeEnd': timeEnd,
        },
      ),
    );
    return response;
  }
}
