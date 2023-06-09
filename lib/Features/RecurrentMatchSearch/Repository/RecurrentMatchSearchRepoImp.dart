import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'RecurrentMatchSearchRepo.dart';

class RecurrentMatchSearchRepoImp implements RecurrentMatchSearchRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> searchRecurrentCourts(
    String accessToken,
    int sportId,
    int cityId,
    String days,
    String timeStart,
    String timeEnd,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().searchRecurrentCourts,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'IdSport': sportId,
          'IdCity': cityId,
          'Days': days,
          'TimeStart': timeStart,
          'TimeEnd': timeEnd,
        },
      ),
    );
    return response;
  }
}
