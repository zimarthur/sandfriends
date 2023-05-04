import 'User.dart';

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

  factory MatchMember.fromJson(Map<String, dynamic> json) {
    return MatchMember(
      user: User.fromJson(json['User']),
      idMatchMember: json['IdMatchMember'],
      waitingApproval: json['WaitingApproval'],
      isMatchCreator: json['IsMatchCreator'],
      refused: json['Refused'],
      quit: json['Quit'] ?? false,
    );
  }
}
