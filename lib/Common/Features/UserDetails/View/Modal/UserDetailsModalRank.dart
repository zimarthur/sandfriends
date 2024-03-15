import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/UserDetails/View/Modal/UserDetailsRankList.dart';

import '../../../../Model/Rank.dart';
import '../../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Components/SFButton.dart';
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
            child: UserDetailsRankList(
              viewModel: widget.viewModel,
            ),
          ),
          SFButton(
            buttonLabel: "Concluído",
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.02,
            ),
            onTap: () => widget.viewModel.setUserRank(context, currentRank),
          )
        ],
      ),
    );
  }
}
