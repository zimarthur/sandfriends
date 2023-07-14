import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepo.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';

class CheckoutRepoImp implements CheckoutRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> matchReservation(
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
      ApiEndPoints().matchReservation,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "SportId": sportId,
          "Date": DateFormat('dd-MM-yyyy').format(date),
          "TimeStart": timeBegin,
          "TimeEnd": timeEnd,
          "Cost": cost,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> recurrentMatchReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    int weekday,
    int timeBegin,
    int timeEnd,
    int cost,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().recurrentMatchReservation,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "SportId": sportId,
          "Weekday": weekday,
          "TimeBegin": timeBegin,
          "TimeEnd": timeEnd,
          "Cost": cost,
        },
      ),
    );
    return response;
  }
}
