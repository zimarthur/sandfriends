import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import 'OpenMatchesRepo.dart';

class OpenMatchesRepoImp implements OpenMatchesRepo {
  final BaseApiService _apiService = NetworkApiService();
}
