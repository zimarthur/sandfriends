import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/ViewModel/TeamDetailsViewModel.dart';

import '../../../../Common/Components/SFAvatarUser.dart';
import '../../../../Common/Components/SFReturnButton.dart';
import '../../../../Common/Utils/Constants.dart';

class TeamDetailsHeader extends StatelessWidget {
  TeamDetailsViewModel viewModel;
  TeamDetailsHeader({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SFReturnButton(
            color: primaryLightBlue,
            isPrimary: false,
          ),
        ),
        SizedBox(
          height: 130,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: secondaryBack,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          defaultBorderRadius,
                        ),
                        topRight: Radius.circular(
                          defaultBorderRadius,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 130,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: defaultPadding,
                        left: defaultPadding,
                      ),
                      child: SFAvatarUser(
                        height: 120,
                        user: viewModel.team.teacher,
                        showRank: false,
                        customBorderColor: primaryLightBlue,
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            viewModel.team.name,
                            style: TextStyle(
                              color: textWhite,
                            ),
                            minFontSize: 16,
                            maxFontSize: 20,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "por ${viewModel.team.teacher.fullName}",
                            style: TextStyle(
                                color: textWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
