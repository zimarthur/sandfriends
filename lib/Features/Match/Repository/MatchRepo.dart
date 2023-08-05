import 'package:flutter/material.dart';

import '../../../Remote/NetworkResponse.dart';

class MatchRepo {
  Future<NetworkResponse?> getMatchInfo(
    BuildContext context,
    String matchUrl,
  ) async {
    return null;
  }

  Future<NetworkResponse?> saveCreatorNotes(
    BuildContext context,
    String accessToken,
    int idMatch,
    String newCreatorNotes,
  ) async {
    return null;
  }

  Future<NetworkResponse?> invitationResponse(
    BuildContext context,
    String accessToken,
    int idMatch,
    int idUser,
    bool accepted,
  ) async {
    return null;
  }

  Future<NetworkResponse?> removeMatchMember(
    BuildContext context,
    String accessToken,
    int idMatch,
    int idUser,
  ) async {
    return null;
  }

  Future<NetworkResponse?> cancelMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    return null;
  }

  Future<NetworkResponse?> leaveMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    return null;
  }

  Future<NetworkResponse?> joinMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
  ) async {
    return null;
  }

  Future<NetworkResponse?> saveOpenMatch(
    BuildContext context,
    String accessToken,
    int idMatch,
    bool isOpenMatch,
    int maxUsers,
  ) async {
    return null;
  }
}
