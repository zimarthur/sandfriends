import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'MatchSearchRepo.dart';

class MatchSearchRepoImp implements MatchSearchRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getAllCities() async {
    NetworkResponse response = await _apiService.getResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().getAllCities,
    );
    return response;
  }
}
