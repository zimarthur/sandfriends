import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'NotificationsRepo.dart';

class NotificationsRepoImp implements NotificationsRepo {
  final BaseApiService _apiService = NetworkApiService();
}
