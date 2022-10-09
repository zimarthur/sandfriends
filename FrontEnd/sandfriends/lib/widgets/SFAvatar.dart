import 'package:flutter/material.dart';
import 'package:sandfriends/theme/app_theme.dart';

import '../models/sport.dart';
import '../models/user.dart';

class SFAvatar extends StatelessWidget {
  final double height;
  final User user;
  final Sport sport;

  SFAvatar({
    required this.height,
    required this.user,
    required this.sport,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: colorFromString(),
      radius: height * 0.5,
      child: CircleAvatar(
        backgroundColor: AppTheme.colors.secondaryPaper,
        radius: height * 0.45,
        child: CircleAvatar(
          backgroundColor: colorFromString(),
          radius: height * 0.42,
          child: Container(
            height: height * 0.42,
            width: height * 0.42,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                "${user.firstName![0].toUpperCase()}${user.lastName![0].toUpperCase()}",
                style: TextStyle(
                  color: AppTheme.colors.secondaryPaper,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color colorFromString() {
    var selectedSportId = sport.idSport;
    var selectedRank =
        user.rank.where((rank) => rank.sport.idSport == selectedSportId).first;
    return Color(int.parse("0xFF${selectedRank.color.replaceAll("#", "")}"));
  }
}
