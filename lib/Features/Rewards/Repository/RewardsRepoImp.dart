import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import 'RewardsRepo.dart';

class RewardsRepoImp implements RewardsRepo {
  final BaseApiService _apiService = NetworkApiService();
}
