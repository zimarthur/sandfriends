import 'package:flutter/material.dart';
import 'package:sandfriends/Features/MatchSearch/View/MatchSearchResultTitle.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/MatchSearchViewModel.dart';
import 'OpenMatchCard.dart';

class OpenMatchesResult extends StatefulWidget {
  MatchSearchViewModel viewModel;
  OpenMatchesResult({Key? key, 
    required this.viewModel,
  }) : super(key: key);
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
          themeColor: primaryBlue,
        ),
        widget.viewModel.openMatches.isEmpty
            ? Container(
                height: 100,
                alignment: Alignment.center,
                child: const Text(
                  "Sem partidas abertas",
                  style: TextStyle(
                    color: textLightGrey,
                  ),
                ),
              )
            : Container(
                height: 220,
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                child: ListView.builder(
                  itemCount: widget.viewModel.openMatches.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    return OpenMatchCard(
                      isReduced: true,
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
