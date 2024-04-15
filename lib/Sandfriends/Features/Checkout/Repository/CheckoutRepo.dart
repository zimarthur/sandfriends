import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Coupon/CouponUser.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/SelectedPayment.dart';

class CheckoutRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> matchReservation(
    BuildContext context,
    String accessToken,
    int idStoreCourt,
    int sportId,
    DateTime date,
    int timeBegin,
    int timeEnd,
    double cost,
    CouponUser? coupon,
    double finalCost,
    SelectedPayment selectedPayment,
    String cpf,
    int? idCreditCard,
    String cvv,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.matchReservation,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "SportId": sportId,
          "Date": DateFormat('dd/MM/yyyy').format(date),
          "TimeStart": timeBegin,
          "TimeEnd": timeEnd,
          "Cost": cost,
          "IdCoupon": coupon != null ? coupon.idCoupon : 0,
          "FinalCost": finalCost,
          "Payment": selectedPayment.index,
          "Cpf": cpf,
          "IdCreditCard": idCreditCard ?? "",
          "Cvv": cvv,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> recurrentMatchReservation(
    BuildContext context,
    String accessToken,
    int idStoreCourt,
    int sportId,
    int weekday,
    List<DateTime> currentMonthDates,
    int timeBegin,
    int timeEnd,
    double cost,
    double totalCost,
    SelectedPayment selectedPayment,
    String cpf,
    int? idCreditCard,
    String cvv,
    bool isRenovating,
    Team? team,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.recurrentMatchReservation,
      jsonEncode(
        <String, Object?>{
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
          "IdTeam": team?.idTeam,
        },
      ),
    );
    return response;
  }

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
      context,
      ApiEndPoints.recurrentMonthAvailableHours,
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

  Future<NetworkResponse> validateCoupon(
    BuildContext context,
    String couponCode,
    int idStore,
    int timeBegin,
    int timeEnd,
    DateTime date,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.validateCoupon,
      jsonEncode(
        <String, Object>{
          "Code": couponCode,
          "IdStore": idStore,
          "TimeBegin": timeBegin,
          "TimeEnd": timeEnd,
          "MatchDate": DateFormat("dd/MM/yyyy").format(date),
        },
      ),
    );
    return response;
  }
}
