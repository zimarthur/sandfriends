import '../../Remote/BaseApiService.dart';
import '../../Remote/NetworkApiService.dart';
import 'UserMatchesRepo.dart';

class UserMatchesRepoImp implements UserMatchesRepo {
  final BaseApiService _apiService = NetworkApiService();
}
