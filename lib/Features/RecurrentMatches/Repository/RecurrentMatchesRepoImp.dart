import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'RecurrentMatchesRepo.dart';

class RecurrentMatchesRepoImp implements RecurrentMatchesRepo {
  final BaseApiService _apiService = NetworkApiService();
}
