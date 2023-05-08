import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'MatchRepo.dart';

class MatchRepoImp implements MatchRepo {
  final BaseApiService _apiService = NetworkApiService();
}
