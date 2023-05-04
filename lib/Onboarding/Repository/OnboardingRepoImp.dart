import 'dart:convert';

import 'package:sandfriends/Onboarding/Repository/OnboardingRepo.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../Remote/ApiEndPoints.dart';
import '../../Remote/BaseApiService.dart';
import '../../Remote/NetworkApiService.dart';

class OnboardingRepoImp implements OnboardingRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getAllCities() async {
    NetworkResponse response = await _apiService.getResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().getAllCities,
    );
    return response;
  }

  @override
  Future<NetworkResponse> addUserInfo(
    String accessToken,
    String firstName,
    String lastName,
    String phoneNumber,
    int idCity,
    int idSport,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().addUserInfo,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'FirstName': firstName,
          'LastName': lastName,
          'PhoneNumber': phoneNumber,
          'IdCity': idCity,
          'IdSport': idSport,
        },
      ),
    );
    return response;
  }
}
