import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Model/Team.dart';

class TeamPaymentForUser {
  Team team;
  List<ClassPlan> teamClassPlan;

  List<AppMatchUser> teamMatches = [];

  List<AppMatchUser> get pricedTeamMatches {
    List<AppMatchUser> matches = [];

    for (var match in teamMatches) {
      if (match.selectedMember != null) {
        if (match.selectedMember!.cost == null) {
          match.selectedMember!.cost = priceForMatch;
        }
      }
      matches.add(match);
    }

    return matches;
  }

  ClassPlan get classPlanForUser {
    ClassPlan classPlan;
    if (teamMatches.length >= 8 &&
        teamClassPlan.any((classPlan) =>
            classPlan.classFrequency == EnumClassFrequency.TwiceWeek)) {
      classPlan = teamClassPlan.firstWhere((classPlan) =>
          classPlan.classFrequency == EnumClassFrequency.TwiceWeek);
    } else if (teamMatches.length >= 4 &&
        teamClassPlan.any((classPlan) =>
            classPlan.classFrequency == EnumClassFrequency.OnceWeek)) {
      classPlan = teamClassPlan.firstWhere((classPlan) =>
          classPlan.classFrequency == EnumClassFrequency.OnceWeek);
    } else {
      classPlan = teamClassPlan.firstWhere(
          (classPlan) => classPlan.classFrequency == EnumClassFrequency.None);
    }
    return classPlan;
  }

  double get priceForMatch {
    return classPlanForUser.price.toDouble();
  }

  double get totalCost {
    double total = 0;
    for (var match in pricedTeamMatches) {
      if (match.selectedMember != null) {
        total += match.selectedMember!.cost!;
      }
    }

    return total;
  }

  double get totalPaid {
    double total = 0;
    for (var match in pricedTeamMatches) {
      if (match.selectedMember != null) {
        if (match.selectedMember!.hasPaid) {
          total += match.selectedMember!.cost!;
        }
      }
    }

    return total;
  }

  double get remainingCost {
    double total = 0;
    for (var match in pricedTeamMatches) {
      if (match.selectedMember != null) {
        if (!match.selectedMember!.hasPaid) {
          total += match.selectedMember!.cost!;
        }
      }
    }
    return total;
  }

  TeamPaymentForUser({
    required this.team,
    required this.teamClassPlan,
  });
}
