import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Common/Model/User/Player_old.dart';
import '../../../../Common/Model/User/UserStore.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class CalendarRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> updateMatchesList(BuildContext context,
      String accessToken, DateTime newSelectedDate) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.updateMatchesList,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "NewSelectedDate": DateFormat("dd/MM/yyyy").format(newSelectedDate),
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> cancelMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
    String? cancelationReason,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.cancelMatchEmployee,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdMatch": idMatch,
          "CancelationReason": cancelationReason ?? "",
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> cancelRecurrentMatch(
    BuildContext context,
    String accessToken,
    int idRecurrentMatch,
    String? cancelationReason,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.cancelRecurrentMatch,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdRecurrentMatch": idRecurrentMatch,
          "CancelationReason": cancelationReason ?? "",
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> blockHour(
    BuildContext context,
    String accessToken,
    int idStoreCourt,
    DateTime date,
    int hour,
    UserStore player,
    int idSport,
    String obs,
    double price,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.blockHour,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "Date": DateFormat("dd/MM/yyyy").format(date),
          "IdHour": hour,
          "IdStorePlayer": player.isStorePlayer ? player.id! : "",
          "IdUser": player.isStorePlayer ? "" : player.id!,
          "IdSport": idSport,
          "BlockedReason": obs,
          "Price": price,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> unblockHour(
    BuildContext context,
    String accessToken,
    int idStoreCourt,
    DateTime date,
    int hour,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.unblockHour,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "Date": DateFormat("dd/MM/yyyy").format(date),
          "IdHour": hour,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> recurrentBlockHour(
    BuildContext context,
    String accessToken,
    int idStoreCourt,
    int weekday,
    int hour,
    UserStore player,
    int idSport,
    String obs,
    double price,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.recurrentBlockHour,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdStoreCourt": idStoreCourt,
          "Weekday": weekday,
          "IdHour": hour,
          "IdStorePlayer": player.isStorePlayer ? player.id! : "",
          "IdUser": player.isStorePlayer ? "" : player.id!,
          "IdSport": idSport,
          "BlockedReason": obs,
          "Price": price,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> recurrentUnblockHour(
    BuildContext context,
    String accessToken,
    int idRecurrentMatch,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.recurrentUnblockHour,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdRecurrentMatch": idRecurrentMatch,
        },
      ),
    );
    return response;
  }
}
