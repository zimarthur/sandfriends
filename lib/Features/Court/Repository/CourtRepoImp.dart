import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'CourtRepo.dart';

class CourtRepoImp implements CourtRepo {
  final BaseApiService _apiService = NetworkApiService();
}
