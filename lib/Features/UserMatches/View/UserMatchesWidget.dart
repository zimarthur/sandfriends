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
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: secondaryBack,
      child: Provider.of<DataProvider>(context, listen: false).matches.isEmpty
          ? Center(
              child: Text(
                "Você ainda não jogou nenhuma partida.",
                style: TextStyle(
                  color: textDarkGrey,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: Provider.of<DataProvider>(context, listen: false)
                  .matches
                  .length,
              itemBuilder: (context, index) {
                return Container(
                  width: width,
                  height: 200,
                  padding: EdgeInsets.only(bottom: 5),
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: 5),
                  child: MatchCard(
                      match: Provider.of<DataProvider>(context).matches[index]),
                );
              },
            ),
    );
  }
}
