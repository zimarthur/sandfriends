import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/UserMatchesViewModel.dart';
import 'MatchCard.dart';

class UserMatchesWidget extends StatefulWidget {
  final UserMatchesViewModel viewModel;
  const UserMatchesWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserMatchesWidget> createState() => _UserMatchesWidgetState();
}

class _UserMatchesWidgetState extends State<UserMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: secondaryBack,
      child: Provider.of<UserProvider>(context, listen: false).matches.isEmpty
          ? const Center(
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
              itemCount: Provider.of<UserProvider>(context, listen: false)
                  .matches
                  .length,
              itemBuilder: (context, index) {
                return Container(
                  width: width,
                  height: 200,
                  padding: const EdgeInsets.only(bottom: 5),
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: 5),
                  child: MatchCard(
                      match: Provider.of<UserProvider>(context).matches[index]),
                );
              },
            ),
    );
  }
}
