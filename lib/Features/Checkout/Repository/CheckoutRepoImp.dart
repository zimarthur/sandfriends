import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepo.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/SelectedPayment.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';

class CheckoutRepoImp implements CheckoutRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> matchReservation(
    BuildContext context,
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
    String cvv,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().matchReservation,
      ),
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
          "Cvv": cvv,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> recurrentMatchReservation(
    BuildContext context,
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
    String cvv,
    bool isRenovating,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().recurrentMatchReservation,
      ),
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
          "Cvv": cvv,
          "IsRenovating": isRenovating,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> recurrentMonthAvailableHours(
    BuildContext context,
    String accessToken,
    int weekday,
    int timeBegin,
    int timeEnd,
    int idStoreCourt,
    bool isRenovating,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().recurrentMonthAvailableHours,
      ),
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "Weekday": weekday,
          "TimeBegin": timeBegin,
          "TimeEnd": timeEnd,
          "IsRenovating": isRenovating,
        },
      ),
    );
    return response;
  }
}
