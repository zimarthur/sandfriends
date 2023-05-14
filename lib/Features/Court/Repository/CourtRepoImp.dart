import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'CourtRepo.dart';

class CourtRepoImp implements CourtRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> courtReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    DateTime date,
    int timeBegin,
    int timeEnd,
    int cost,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().courtReservation,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "SportId": sportId,
          "Date": DateFormat('yyyy-MM-dd').format(date),
          "TimeBegin": timeBegin,
          "TimeEnd": timeEnd,
          "Cost": cost,
        },
      ),
    );
    return response;
  }
}
