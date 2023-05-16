import '../../../Remote/NetworkResponse.dart';

class MatchRepo {
  Future<NetworkResponse?> getMatchInfo(
    String matchUrl,
  ) async {}

  Future<NetworkResponse?> saveCreatorNotes(
    String accessToken,
    int idMatch,
    String newCreatorNotes,
  ) async {}

  Future<NetworkResponse?> invitationResponse(
    String accessToken,
    int idMatch,
    int idUser,
    bool accepted,
  ) async {}

  Future<NetworkResponse?> removeMatchMember(
    String accessToken,
    int idMatch,
    int idUser,
  ) async {}

  Future<NetworkResponse?> cancelMatch(
    String accessToken,
    int idMatch,
  ) async {}

  Future<NetworkResponse?> leaveMatch(
    String accessToken,
    int idMatch,
  ) async {}

  Future<NetworkResponse?> joinMatch(
    String accessToken,
    int idMatch,
  ) async {}

  Future<NetworkResponse?> saveOpenMatch(
    String accessToken,
    int idMatch,
    bool isOpenMatch,
    int maxUsers,
  ) async {}
}
