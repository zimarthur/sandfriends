import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';

import '../../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/UserMatchesViewModel.dart';
import '../Mobile/MatchCard.dart';

class UserMatchesWidgetWeb extends StatefulWidget {
  final UserMatchesViewModel viewModel;
  const UserMatchesWidgetWeb({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserMatchesWidgetWeb> createState() => _UserMatchesWidgetWebState();
}

class _UserMatchesWidgetWebState extends State<UserMatchesWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: secondaryBackWeb,
      child: Column(
        children: [
          WebHeader(showSport: false),
          Expanded(
            child: SizedBox(
              width: width * defaultWebScreenWidth,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      "Suas partidas",
                      style: TextStyle(
                        color: textBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      "Veja suas reservas e as partidas que já jogou!",
                      style: TextStyle(
                        color: textDarkGrey,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 2 * defaultPadding,
                    ),
                    if (Provider.of<UserProvider>(context).matches.isEmpty)
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            "Você ainda não jogou uma partida",
                            style: TextStyle(
                              color: textDarkGrey,
                            ),
                          ),
                        ),
                      ),
                    if (Provider.of<UserProvider>(context)
                        .nextMatches
                        .isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 2 * defaultPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Próximas partidas"),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: Provider.of<UserProvider>(context)
                                    .nextMatches
                                    .length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 300,
                                    margin: EdgeInsets.only(
                                      right: defaultPadding,
                                    ),
                                    child: MatchCard(
                                        match:
                                            Provider.of<UserProvider>(context)
                                                .nextMatches[index]),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    if (Provider.of<UserProvider>(context)
                        .pastMatches
                        .isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Últimas partidas"),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          SizedBox(
                            height: 200,
                            child: Scrollbar(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: Provider.of<UserProvider>(context)
                                    .pastMatches
                                    .length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 300,
                                    margin: EdgeInsets.only(
                                      right: defaultPadding,
                                    ),
                                    child: MatchCard(
                                        match:
                                            Provider.of<UserProvider>(context)
                                                .pastMatches[index]),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 3 * defaultPadding,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      // Provider.of<UserProvider>(context, listen: false).matches.isEmpty
      //     ? const Center(
      //         child: Text(
      //           "Você ainda não jogou nenhuma partida.",
      //           style: TextStyle(
      //             color: textDarkGrey,
      //           ),
      //         ),
      //       )
      //     : ListView.builder(
      //         scrollDirection: Axis.vertical,
      //         shrinkWrap: true,
      //         itemCount: Provider.of<UserProvider>(context, listen: false)
      //             .matches
      //             .length,
      //         itemBuilder: (context, index) {
      //           return Container(
      //             width: width,
      //             height: 200,
      //             padding: const EdgeInsets.only(bottom: 5),
      //             margin: EdgeInsets.symmetric(
      //                 horizontal: width * 0.05, vertical: 5),
      //             child: MatchCard(
      //                 match: Provider.of<UserProvider>(context).matches[index]),
      //           );
      //         },
      //       ),
    );
  }
}
