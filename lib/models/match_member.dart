import 'user.dart';

class MatchMember {
  final User user;
  final int idMatchMember;
  final bool waitingApproval;
  final bool isMatchCreator;
  final bool refused;
  final bool quit;

  MatchMember({
    required this.user,
    required this.idMatchMember,
    required this.waitingApproval,
    required this.isMatchCreator,
    required this.refused,
    required this.quit,
  });
}

MatchMember matchMemberFromJson(Map<String, dynamic> json) {
  var newMatchMember = MatchMember(
    user: userFromJson(json['User']),
    idMatchMember: json['IdMatchMember'],
    waitingApproval: json['WaitingApproval'],
    isMatchCreator: json['IsMatchCreator'],
    refused: json['Refused'],
    quit: json['Quit'] ?? false,
  );
  return newMatchMember;
}
