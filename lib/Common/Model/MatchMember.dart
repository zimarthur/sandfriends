import 'User/UserComplete.dart';

class MatchMember {
  final UserComplete user;
  final int idMatchMember;
  final bool waitingApproval;
  final bool isMatchCreator;
  final bool refused;
  final bool quit;
  bool hasPaid;

  double? cost;

  MatchMember({
    required this.user,
    required this.idMatchMember,
    required this.waitingApproval,
    required this.isMatchCreator,
    required this.refused,
    required this.quit,
    required this.hasPaid,
    required this.cost,
  });

  factory MatchMember.fromJson(Map<String, dynamic> json) {
    return MatchMember(
      user: UserComplete.fromJson(json['User']),
      idMatchMember: json['IdMatchMember'],
      waitingApproval: json['WaitingApproval'],
      isMatchCreator: json['IsMatchCreator'],
      refused: json['Refused'],
      quit: json['Quit'] ?? false,
      hasPaid: json['HasPaid'] ?? false,
      cost: json["Cost"] != null ? double.parse(json["Cost"]) : null,
    );
  }
}
