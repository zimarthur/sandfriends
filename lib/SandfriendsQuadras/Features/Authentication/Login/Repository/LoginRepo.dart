import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> login(
    BuildContext context,
    String email,
    String password,
    Tuple2<bool?, String?>? notificationsConfig,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.loginEmployee,
      jsonEncode(
        <String, Object>{
          "Email": email,
          "Password": password,
          'UpdateNotifications': notificationsConfig != null,
          'AllowNotifications': notificationsConfig != null
              ? notificationsConfig.item1 ?? false
              : false,
          'NotificationsToken': notificationsConfig != null
              ? notificationsConfig.item2 ?? ""
              : "",
          'IsRequestFromApp': !kIsWeb,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> validateToken(
      BuildContext context, String accessToken) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.validateTokenEmployee,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          'IsRequestFromApp': !kIsWeb,
        },
      ),
    );
    return response;
  }
}
