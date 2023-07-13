import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepo.dart';

import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';

class CheckoutRepoImp implements CheckoutRepo {
  final BaseApiService _apiService = NetworkApiService();
}
