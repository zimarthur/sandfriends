import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/SharedComponents/Model/Rank.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';

import '../../../../SharedComponents/Model/Gender.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';
import '../../../../oldApp/widgets/SF_Button.dart';
import '../../../../oldApp/widgets/SF_TextField.dart';

class UserDetailsModalRank extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsModalRank({
    required this.viewModel,
  });

  @override
  State<UserDetailsModalRank> createState() => _UserDetailsModalRankState();
}

class _UserDetailsModalRankState extends State<UserDetailsModalRank> {
  late Rank currentRank;
  List<Rank> availableRanks = [];

  @override
  void initState() {
    availableRanks = Provider.of<DataProvider>(context, listen: false)
        .ranks
        .where(
          (rank) =>
              rank.sport.idSport == widget.viewModel.displayedSport.idSport,
        )
        .toList();
    currentRank = widget.viewModel.userEdited.ranks.firstWhere(
      (rank) => rank.sport.idSport == widget.viewModel.displayedSport.idSport,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height * 0.3,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableRanks.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentRank = availableRanks[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.05),
                    decoration: BoxDecoration(
                      color: secondaryBack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: currentRank == availableRanks[index]
                            ? primaryBlue
                            : textLightGrey,
                        width: currentRank == availableRanks[index] ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      Provider.of<DataProvider>(context, listen: false)
                          .genders[index]
                          .name,
                      style: TextStyle(
                        color: currentRank == availableRanks[index]
                            ? textBlue
                            : textDarkGrey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SFButton(
            buttonLabel: "Concluído",
            buttonType: ButtonType.Primary,
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.02,
            ),
            onTap: () => widget.viewModel.setUserRank(currentRank),
          )
        ],
      ),
    );
  }
}
