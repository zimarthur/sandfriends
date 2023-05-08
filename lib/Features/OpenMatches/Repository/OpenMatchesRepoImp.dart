import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'OpenMatchesRepo.dart';

class OpenMatchesRepoImp implements OpenMatchesRepo {
  final BaseApiService _apiService = NetworkApiService();
}
