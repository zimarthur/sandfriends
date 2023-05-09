import 'dart:convert';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'OnboardingRepo.dart';

class OnboardingRepoImp implements OnboardingRepo {
  final BaseApiService _apiService = NetworkApiService();

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
