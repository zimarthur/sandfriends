import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'MatchSearchRepo.dart';

class MatchSearchRepoImp implements MatchSearchRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> searchCourts(
    BuildContext context,
    String accessToken,
    int sportId,
    int cityId,
    DateTime dateStart,
    DateTime dateEnd,
    int timeStart,
    int timeEnd,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().searchCourts,
      ),
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'IdSport': sportId,
          'IdCity': cityId,
          'DateStart': DateFormat("dd-MM-yyyy").format(dateStart),
          'DateEnd': DateFormat("dd-MM-yyyy").format(dateEnd),
          'TimeStart': timeStart,
          'TimeEnd': timeEnd,
        },
      ),
    );
    return response;
  }
}
