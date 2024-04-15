import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import '../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../Common/Model/Sport.dart';
import '../../Common/Utils/Constants.dart';
import 'SFLoading.dart';

class SFAvatarUser extends StatelessWidget {
  final double height;
  final User user;
  final Sport? sport;
  final String? editFile;
  final bool showRank;
  final VoidCallback? onTap;
  final Color? customBorderColor;

  SFAvatarUser({
    Key? key,
    required this.height,
    required this.user,
    this.sport,
    this.editFile,
    required this.showRank,
    this.onTap,
    this.customBorderColor,
  }) : super(key: key);

  Color? rankTile;
  Color? avatarBackground;

  @override
  Widget build(BuildContext context) {
    if (showRank) {
      UserComplete userComplete = user as UserComplete;
      var selectedSportId = sport!.idSport;
      var selectedRank = userComplete.ranks
          .where((rank) => rank.sport.idSport == selectedSportId)
          .first;
      if (selectedRank.color == "0") {
        rankTile = Colors.transparent;
        avatarBackground = primaryBlue;
      } else {
        rankTile =
            Color(int.parse("0xFF${selectedRank.color.replaceAll("#", "")}"));
        avatarBackground =
            Color(int.parse("0xFF${selectedRank.color.replaceAll("#", "")}"));
      }
    } else {
      rankTile = Colors.transparent;
      avatarBackground = primaryBlue;
    }

    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: rankTile,
        radius: height * 0.5,
        child: CircleAvatar(
          backgroundColor: customBorderColor ?? secondaryPaper,
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
                            user.firstName == null || user.lastName == null
                                ? ""
                                : "${user.firstName![0].toUpperCase()}${user.lastName![0].toUpperCase()}",
                            style: const TextStyle(
                              color: secondaryPaper,
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
                            imageUrl: Provider.of<EnvironmentProvider>(context,
                                    listen: false)
                                .urlBuilder(user.photo!, isImage: true),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Padding(
                              padding: EdgeInsets.all(height * 0.3),
                              child: SFLoading(),
                            ),
                            errorWidget: (context, url, error) => const Center(
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
