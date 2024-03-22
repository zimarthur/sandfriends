import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class AppInfoRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> removeUser(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.removeUser,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> setUserNotifications(
    BuildContext context,
    String accessToken,
    bool allowNotifications,
    String notificationsToken,
    bool allowNotificationsCoupons,
    bool allowNotificationsOpenMatches,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.setUserNotifications,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "NotificationsToken": notificationsToken,
          "AllowNotifications": allowNotifications,
          "AllowNotificationsCoupons": allowNotificationsCoupons,
          "AllowNotificationsOpenMatches": allowNotificationsOpenMatches,
        },
      ),
    );
    return response;
  }
}
