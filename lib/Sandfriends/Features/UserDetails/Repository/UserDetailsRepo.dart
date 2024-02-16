import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/User.dart';

class UserDetailsRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> updateUserInfo(
      BuildContext context, User user) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.updateUserInfo,
      jsonEncode(
        user.toJson(),
      ),
    );
    return response;
  }
}
