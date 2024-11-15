import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Features/UserMatches/View/Mobile/MatchCard.dart';
import '../../../../Providers/UserProvider/UserProvider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../Model/HomeTabsEnum.dart';
import '../../ViewModel/HomeViewModel.dart';

class FeedNextMatches extends StatefulWidget {
  final HomeViewModel viewModel;
  const FeedNextMatches({
    Key? key,
    required this.viewModel,
  }) : super(key: key);
  @override
  State<FeedNextMatches> createState() => _FeedNextMatchesState();
}

class _FeedNextMatchesState extends State<FeedNextMatches> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: width * 0.02,
            right: width * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/court.svg",
                    color: primaryBlue,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: width * 0.02,
                    ),
                  ),
                  const Text(
                    "Próximas Partidas",
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: width,
          height: 200,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Provider.of<UserProvider>(context).nextMatches.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                  decoration: BoxDecoration(
                    color: divider.withAlpha(126),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          "Nenhuma partida agendada",
                          style: TextStyle(
                            color: textDarkGrey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                      ),
                      InkWell(
                        onTap: () => widget.viewModel.changeTab(
                          context,
                          HomeTabs.MatchSearch,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              r"assets/icon/navigation/schedule_screen_selected.svg",
                              height: 24,
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: width * 0.02)),
                            const Flexible(
                              child: Text(
                                "Agende já seu horário",
                                style: TextStyle(
                                  color: textBlue,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: textBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<UserProvider>(context).nextMatches.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: width * 0.6,
                      padding: const EdgeInsets.only(bottom: 5),
                      margin: index ==
                              Provider.of<UserProvider>(context)
                                      .nextMatches
                                      .length -
                                  1
                          ? EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                            )
                          : EdgeInsets.only(
                              left: width * 0.03,
                            ),
                      child: MatchCard(
                          match: Provider.of<UserProvider>(context)
                              .nextMatches[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
