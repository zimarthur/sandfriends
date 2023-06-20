import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import 'RecurrentMatchesRepo.dart';

class RecurrentMatchesRepoImp implements RecurrentMatchesRepo {
  final BaseApiService _apiService = NetworkApiService();
}
