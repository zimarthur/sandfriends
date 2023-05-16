import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/MatchSearch/View/MatchSearchResultTitle.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/MatchSearchViewModel.dart';
import 'OpenMatchCard.dart';

class OpenMatchesResult extends StatefulWidget {
  MatchSearchViewModel viewModel;
  OpenMatchesResult({
    required this.viewModel,
  });
  @override
  State<OpenMatchesResult> createState() => _OpenMatchesResultState();
}

class _OpenMatchesResultState extends State<OpenMatchesResult> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        MatchSearchResultTitle(
          title: "Partidas Abertas",
          iconPath: r'assets\icon\trophy.svg',
          description: "Escolha uma partida e desafie novos jogadores",
        ),
        Container(
          height: 220,
          margin: EdgeInsets.symmetric(vertical: height * 0.02),
          child: widget.viewModel.openMatches.isEmpty
              ? Container(
                  margin: EdgeInsets.symmetric(
                    vertical: height * 0.04,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Sem partidas abertas",
                    style: TextStyle(
                      color: textLightGrey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: widget.viewModel.openMatches.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    return OpenMatchCard(
                      match: widget.viewModel.openMatches[index],
                      onTap: (matchUrl) =>
                          widget.viewModel.goToMatch(context, matchUrl),
                    );
                  }),
                ),
        ),
      ],
    );
  }
}
