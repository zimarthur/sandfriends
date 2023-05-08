import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'RewardsRepo.dart';

class RewardsRepoImp implements RewardsRepo {
  final BaseApiService _apiService = NetworkApiService();
}
