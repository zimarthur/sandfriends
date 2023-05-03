import 'package:sandfriends/Onboarding/Repository/OnboardingRepo.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../Remote/ApiEndPoints.dart';
import '../../Remote/BaseApiService.dart';
import '../../Remote/NetworkApiService.dart';

class OnboardingRepoImp implements OnboardingRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse?> getAllCities() async {
    NetworkResponse response = await _apiService.getResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().getAllCities,
    );
    return response;
  }
}
