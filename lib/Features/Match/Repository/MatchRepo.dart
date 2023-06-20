import '../../../Remote/NetworkResponse.dart';

class MatchRepo {
  Future<NetworkResponse?> getMatchInfo(
    String matchUrl,
  ) async {
    return null;
  }

  Future<NetworkResponse?> saveCreatorNotes(
    String accessToken,
    int idMatch,
    String newCreatorNotes,
  ) async {
    return null;
  }

  Future<NetworkResponse?> invitationResponse(
    String accessToken,
    int idMatch,
    int idUser,
    bool accepted,
  ) async {
    return null;
  }

  Future<NetworkResponse?> removeMatchMember(
    String accessToken,
    int idMatch,
    int idUser,
  ) async {
    return null;
  }

  Future<NetworkResponse?> cancelMatch(
    String accessToken,
    int idMatch,
  ) async {
    return null;
  }

  Future<NetworkResponse?> leaveMatch(
    String accessToken,
    int idMatch,
  ) async {
    return null;
  }

  Future<NetworkResponse?> joinMatch(
    String accessToken,
    int idMatch,
  ) async {
    return null;
  }

  Future<NetworkResponse?> saveOpenMatch(
    String accessToken,
    int idMatch,
    bool isOpenMatch,
    int maxUsers,
  ) async {
    return null;
  }
}
