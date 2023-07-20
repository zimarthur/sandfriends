import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepo.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/SelectedPayment.dart';

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
    SelectedPayment selectedPayment,
    String cpf,
    int? idCreditCard,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().matchReservation,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "SportId": sportId,
          "Date": DateFormat('dd/MM/yyyy').format(date),
          "TimeStart": timeBegin,
          "TimeEnd": timeEnd,
          "Cost": cost,
          "Payment": selectedPayment.index,
          "Cpf": cpf,
          "IdCreditCard": idCreditCard ?? "",
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
    List<DateTime> currentMonthDates,
    int timeBegin,
    int timeEnd,
    int cost,
    int totalCost,
    SelectedPayment selectedPayment,
    String cpf,
    int? idCreditCard,
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
          "CurrentMonthDates": [
            for (var date in currentMonthDates)
              DateFormat("dd/MM/yyyy").format(date),
          ],
          "TimeBegin": timeBegin,
          "TimeEnd": timeEnd,
          "Cost": cost,
          "TotalCost": totalCost,
          "Payment": selectedPayment.index,
          "Cpf": cpf,
          "IdCreditCard": idCreditCard ?? "",
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> recurrentMonthAvailableHours(
    String accessToken,
    int weekday,
    int timeBegin,
    int timeEnd,
    int idStoreCourt,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().recurrentMonthAvailableHours,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "Weekday": weekday,
          "TimeBegin": timeBegin,
          "TimeEnd": timeEnd,
        },
      ),
    );
    return response;
  }
}
