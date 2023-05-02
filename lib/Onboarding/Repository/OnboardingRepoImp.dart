import 'package:sandfriends/Onboarding/Repository/OnboardingRepo.dart';

import '../../Remote/BaseApiService.dart';
import '../../Remote/NetworkApiService.dart';

class OnboardingRepoImp implements OnboardingRepo {
  final BaseApiService _apiService = NetworkApiService();
}
