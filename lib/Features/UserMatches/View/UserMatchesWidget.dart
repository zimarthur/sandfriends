import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/UserMatches/ViewModel/UserMatchesViewModel.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'MatchCard.dart';

class UserMatchesWidget extends StatefulWidget {
  UserMatchesViewModel viewModel;
  UserMatchesWidget({
    required this.viewModel,
  });

  @override
  State<UserMatchesWidget> createState() => _UserMatchesWidgetState();
}

class _UserMatchesWidgetState extends State<UserMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount:
            Provider.of<DataProvider>(context, listen: false).matches.length,
        itemBuilder: (context, index) {
          return MatchCard(
            match: Provider.of<DataProvider>(context, listen: false)
                .matches[index],
          );
        },
      ),
    );
  }
}
