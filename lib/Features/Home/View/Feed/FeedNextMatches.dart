import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Home/Model/HomeTabsEnum.dart';
import 'package:sandfriends/Features/Home/ViewModel/HomeViewModel.dart';
import 'package:sandfriends/Features/UserMatches/View/MatchCard.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../../SharedComponents/View/SFLoading.dart';
import '../../../../Utils/SFDateTime.dart';

class FeedNextMatches extends StatefulWidget {
  HomeViewModel viewModel;
  FeedNextMatches({
    required this.viewModel,
  });
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
                    r"assets\icon\court.svg",
                    color: primaryBlue,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: width * 0.02,
                    ),
                  ),
                  Text(
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
          padding: EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Provider.of<DataProvider>(context).nextMatches.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                  decoration: BoxDecoration(
                    color: divider,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Você não tem nenhuma partida agendada",
                          style: TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                      ),
                      InkWell(
                        onTap: () => widget.viewModel.changeTab(
                          HomeTabs.SportSelector,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              r"assets\icon\navigation\schedule_screen_selected.svg",
                              height: 24,
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: width * 0.02)),
                            Flexible(
                              child: Text(
                                "Agende já seu horário",
                                style: TextStyle(
                                  color: textBlue,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
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
                      Provider.of<DataProvider>(context).nextMatches.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: width * 0.6,
                      padding: EdgeInsets.only(bottom: 5),
                      margin: index ==
                              Provider.of<DataProvider>(context)
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
                          match: Provider.of<DataProvider>(context)
                              .nextMatches[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
