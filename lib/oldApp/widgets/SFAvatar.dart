import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/oldApp/theme/app_theme.dart';
import 'package:sandfriends/SharedComponents/View/SFLoading.dart';

import '../../SharedComponents/Model/Sport.dart';
import '../../SharedComponents/Model/User.dart';

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

  Color? rankTile;
  Color? avatarBackground;

  @override
  Widget build(BuildContext context) {
    if (showRank) {
      var selectedSportId = sport!.idSport;
      var selectedRank = user.rank
          .where((rank) => rank.sport.idSport == selectedSportId)
          .first;
      if (selectedRank.color == "0") {
        rankTile = Colors.transparent;
        avatarBackground = AppTheme.colors.primaryBlue;
      } else {
        rankTile =
            Color(int.parse("0xFF${selectedRank.color.replaceAll("#", "")}"));
        avatarBackground =
            Color(int.parse("0xFF${selectedRank.color.replaceAll("#", "")}"));
      }
    } else {
      rankTile = Colors.transparent;
      avatarBackground = AppTheme.colors.primaryBlue;
    }

    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: rankTile,
        radius: height * 0.5,
        child: CircleAvatar(
          backgroundColor: AppTheme.colors.secondaryPaper,
          radius: height * 0.45,
          child: CircleAvatar(
            backgroundColor: avatarBackground,
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
                : user.photo == null || user.photo!.isEmpty
                    ? SizedBox(
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
                    : AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(height * 0.42),
                          child: CachedNetworkImage(
                            imageUrl: user.photo!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Padding(
                              padding: EdgeInsets.all(height * 0.3),
                              child: SFLoading(),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
