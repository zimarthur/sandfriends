import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../SharedComponents/Model/Rank.dart';
import '../../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../SharedComponents/View/SFButton.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/UserDetailsViewModel.dart';

class UserDetailsModalRank extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsModalRank({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsModalRank> createState() => _UserDetailsModalRankState();
}

class _UserDetailsModalRankState extends State<UserDetailsModalRank> {
  late Rank currentRank;
  List<Rank> availableRanks = [];

  @override
  void initState() {
    availableRanks = Provider.of<CategoriesProvider>(context, listen: false)
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
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
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
                        color: currentRank.idRankCategory ==
                                availableRanks[index].idRankCategory
                            ? primaryBlue
                            : textLightGrey,
                        width: currentRank.idRankCategory ==
                                availableRanks[index].idRankCategory
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Text(
                      availableRanks[index].name,
                      style: TextStyle(
                        color: currentRank.idRankCategory ==
                                availableRanks[index].idRankCategory
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
