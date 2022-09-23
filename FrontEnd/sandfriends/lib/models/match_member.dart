import 'package:flutter/material.dart';

import 'user.dart';

class MatchMember {
  User? user;
  int? idMatchMember;
  bool? waitingApproval;
  bool? matchCreator;

  MatchMember({
    required this.user,
    required this.idMatchMember,
    required this.waitingApproval,
    required this.matchCreator,
  });
}
