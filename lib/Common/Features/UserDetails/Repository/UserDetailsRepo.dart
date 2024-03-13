import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class UserDetailsRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> updateUserInfo(
      BuildContext context, UserComplete user) async {
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
