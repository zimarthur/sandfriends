import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Model/Rank.dart';

class UserDetailsRankList extends StatefulWidget {
  UserDetailsRankList({
    super.key,
  });

  @override
  State<UserDetailsRankList> createState() => _UserDetailsRankListState();
}

class _UserDetailsRankListState extends State<UserDetailsRankList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserDetailsViewModel>(context);
    return LayoutBuilder(builder: (layoutContext, layoutCOnstraints) {
      return SizedBox(
        height: layoutCOnstraints.maxHeight,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: viewModel.ranksForDisplayedSport.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => viewModel.setUserRank(
                  context, viewModel.ranksForDisplayedSport[index]),
              child: Container(
                margin: EdgeInsets.only(bottom: defaultPadding / 2),
                padding: EdgeInsets.symmetric(
                    vertical: defaultPadding / 2, horizontal: defaultPadding),
                decoration: BoxDecoration(
                  color: secondaryBack,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: viewModel.userRankForSport.idRankCategory ==
                            viewModel
                                .ranksForDisplayedSport[index].idRankCategory
                        ? primaryBlue
                        : textLightGrey,
                    width: viewModel.userRankForSport.idRankCategory ==
                            viewModel
                                .ranksForDisplayedSport[index].idRankCategory
                        ? 2
                        : 1,
                  ),
                ),
                child: Text(
                  viewModel.ranksForDisplayedSport[index].name,
                  style: TextStyle(
                    color: viewModel.userRankForSport.idRankCategory ==
                            viewModel
                                .ranksForDisplayedSport[index].idRankCategory
                        ? textBlue
                        : textDarkGrey,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
