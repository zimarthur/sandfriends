import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sandfriends/theme/app_theme.dart';

import '../models/sport.dart';
import '../models/user.dart';

class SFAvatar extends StatelessWidget {
  final double height;
  final User user;
  final Sport? sport;
  final String? editFile;
  final bool showRank;
  final VoidCallback? onTap;

  SFAvatar({
    required this.height,
    required this.user,
    this.sport,
    this.editFile,
    required this.showRank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: colorFromString(),
        radius: height * 0.5,
        child: CircleAvatar(
          backgroundColor: AppTheme.colors.secondaryPaper,
          radius: height * 0.45,
          child: CircleAvatar(
            backgroundColor: colorFromString(),
            radius: height * 0.42,
            child: editFile != null
                ? AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(height * 0.42),
                      child: Image.file(
                        File(
                          editFile!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : user.photo == null
                    ? Container(
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
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(height * 0.42),
                        child: Image.network(
                            "https://www.sandfriends.com.br/img/${user.photo!}"),
                      ),
          ),
        ),
      ),
    );
  }

  Color colorFromString() {
    if (showRank) {
      var selectedSportId = sport!.idSport;
      var selectedRank = user.rank
          .where((rank) => rank.sport.idSport == selectedSportId)
          .first;
      return Color(int.parse("0xFF${selectedRank.color.replaceAll("#", "")}"));
    } else {
      return AppTheme.colors.primaryBlue;
    }
  }
}
