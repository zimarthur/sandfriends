import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/TeamPaymentForUser.dart';

class UserClassPayment {
  UserStore user;
  List<TeamPaymentForUser> teamPayments = [];

  List<AppMatchUser> get totalMatches {
    List<AppMatchUser> matches = [];
    for (var teamPayment in teamPayments) {
      for (var match in teamPayment.teamMatches) {
        matches.add(match);
      }
    }
    return matches;
  }

  double get totalCost {
    double total = 0;
    for (var teamPayment in teamPayments) {
      total += teamPayment.totalCost;
    }
    return total;
  }

  double get totalPaid {
    double total = 0;
    for (var teamPayment in teamPayments) {
      total += teamPayment.totalPaid;
    }
    return total;
  }

  double get remainingCost {
    double total = 0;
    for (var teamPayment in teamPayments) {
      total += teamPayment.remainingCost;
    }
    return total;
  }

  bool get hasPaidAllClasses {
    return !totalMatches.any((match) => match.selectedMember!.hasPaid == false);
  }

  UserClassPayment({
    required this.user,
  });
}
