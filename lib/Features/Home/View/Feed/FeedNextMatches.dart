import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Home/Model/HomeTabsEnum.dart';
import 'package:sandfriends/Features/Home/ViewModel/HomeViewModel.dart';
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
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.05,
              ),
              child: Provider.of<DataProvider>(context).nextMatches.isEmpty
                  ? Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03, vertical: height * 0.02),
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.03, vertical: height * 0.02),
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
                            padding: EdgeInsets.only(top: height * 0.04),
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
                                    padding:
                                        EdgeInsets.only(right: width * 0.02)),
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
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/match_screen');
                            // context.goNamed('match_screen', params: {
                            //   'matchUrl': Provider.of<UserProvider>(context,
                            //           listen: false)
                            //       .nextMatchList[index]
                            //       .matchUrl,
                            //   'returnTo': 'home',
                            //   'returnToParam': 'initialPage',
                            //   'returnToParamValue': 'feed_screen',
                            // });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.01),
                            width: width * 0.55,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: textLightGrey,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(1.0, 1.0),
                                )
                              ],
                              color: secondaryPaper,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: height * 0.15,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          Provider.of<DataProvider>(context)
                                              .nextMatches[index]
                                              .sport
                                              .photoUrl,
                                      width: width * 0.55,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Center(
                                        child: SFLoading(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: Icon(Icons.dangerous),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: width * 0.02,
                                  top: height * 0.07,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: secondaryPaper.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    height: height * 0.07,
                                    width: height * 0.07,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: height * 0.03,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "${Provider.of<DataProvider>(context).nextMatches[index].date.day}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.025,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "${monthsPortuguese[Provider.of<DataProvider>(context).nextMatches[index].date.month - 1]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: height * 0.15,
                                  child: Container(
                                    height: height * 0.08,
                                    width: width * 0.55,
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: height * 0.03,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              "Partida de ${Provider.of<DataProvider>(context).nextMatches[index].matchCreator.firstName}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: textBlue,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.01),
                                          height: height * 0.02,
                                          width: width * 0.55,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  r"assets\icon\clock.svg",
                                                  color: textDarkGrey,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width * 0.01),
                                                ),
                                                Text(
                                                  "${Provider.of<DataProvider>(context).nextMatches[index].timeBegin} - ${Provider.of<DataProvider>(context).nextMatches[index].timeFinish}",
                                                  style: TextStyle(
                                                    color: textDarkGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.01),
                                          height: height * 0.02,
                                          width: width * 0.55,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  r"assets\icon\location_ping.svg",
                                                  color: textDarkGrey,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width * 0.01),
                                                ),
                                                Text(
                                                  Provider.of<DataProvider>(
                                                          context)
                                                      .nextMatches[index]
                                                      .court
                                                      .store
                                                      .name,
                                                  style: TextStyle(
                                                    color: textDarkGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      );
    });
  }
}
