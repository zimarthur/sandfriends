import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Home/View/Mobile/CourtOccupationWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends_web/Features/Home/View/Mobile/FilterChip.dart';
import 'package:sandfriends_web/Features/Home/View/Mobile/HomeHeader.dart';
import 'package:sandfriends_web/Features/Menu/View/Mobile/SFStandardHeader.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/MenuProvider.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'KPI.dart';
import 'MatchCard.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  final HomeViewModel viewModel = HomeViewModel();
  final pageController = ScrollController();
  final listController = ScrollController();

  bool areMatchesExpanded = false;
  @override
  void initState() {
    viewModel.initHomeScreen(context);
    pageController.addListener(() {
      if (pageController.position.atEdge) {
        if (listController.position.pixels == 0) {
          areMatchesExpanded = false;
        } else {
          areMatchesExpanded = true;
        }
      }
    });
    listController.addListener(() {
      if (listController.position.atEdge &&
          listController.position.pixels == 0) {
        pageController.animateTo(0,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      } else if (!areMatchesExpanded && listController.position.pixels > 50) {
        pageController.animateTo(pageController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              HomeHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxHeight = constraints.maxHeight;
                    return Container(
                      height: maxHeight,
                      color: secondaryBack,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          viewModel.updateViewModel(context);
                        },
                        child: ListView(
                          controller: pageController,
                          physics: PageScrollPhysics(),
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: KPI(
                                          title: "Faturamento hoje",
                                          value: viewModel.todaysProfit
                                              .toInt()
                                              .toString(),
                                          iconPath: r"assets/icon/money.svg",
                                          primaryColor: success,
                                          secondaryColor: success50,
                                          isCurrency: true,
                                        ),
                                      ),
                                      SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Expanded(
                                        child: KPI(
                                          title: "Partidas hoje",
                                          value: viewModel.matches.length
                                              .toString(),
                                          iconPath: r"assets/icon/court.svg",
                                          primaryColor: blueText,
                                          secondaryColor: blueBg,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: CourtOccupationWidget(
                                    viewModel: viewModel,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: maxHeight,
                              child: LayoutBuilder(builder:
                                  (matchesContext, matchesConstraints) {
                                return Container(
                                  height: 500,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2 * defaultPadding),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: defaultPadding),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Partidas hoje",
                                                style: TextStyle(
                                                    color: textBlue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            vertical: defaultPadding / 2,
                                            horizontal: defaultPadding,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SFFilterChip(
                                                        title: "Agora",
                                                        isEnabled:
                                                            viewModel.filterNow,
                                                        onTap: () => viewModel
                                                            .onTapFilterNow(),
                                                      ),
                                                      for (var courtFilter
                                                          in viewModel
                                                              .filterCourts)
                                                        SFFilterChip(
                                                          title: courtFilter
                                                              .court
                                                              .description,
                                                          isEnabled: courtFilter
                                                              .isFiltered,
                                                          onTap: () => viewModel
                                                              .onTapFilterCourt(
                                                                  courtFilter),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (viewModel.hasAnyFilter)
                                                InkWell(
                                                  onTap: () =>
                                                      viewModel.clearFilter(),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left:
                                                                defaultPadding /
                                                                    2),
                                                    child: SvgPicture.asset(
                                                      r"assets/icon/delete_filter.svg",
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: defaultPadding,
                                            vertical: defaultPadding / 2,
                                          ),
                                          width: width,
                                          child: ListView.builder(
                                            itemCount:
                                                viewModel.hourMatches.length,
                                            controller: listController,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: defaultPadding / 2,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          2 * defaultPadding,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              r"assets/icon/clock.svg"),
                                                          SizedBox(
                                                            width:
                                                                defaultPadding /
                                                                    2,
                                                          ),
                                                          Text(
                                                            viewModel
                                                                .hourMatches[
                                                                    index]
                                                                .hour
                                                                .hourString,
                                                            style: TextStyle(
                                                              color:
                                                                  primaryBlue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 3,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: primaryBlue,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical:
                                                            defaultPadding / 2,
                                                      ),
                                                      child: viewModel
                                                              .hourMatches[
                                                                  index]
                                                              .matches
                                                              .isEmpty
                                                          ? Center(
                                                              child: Text(
                                                                "sem agendamentos",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      textDarkGrey,
                                                                ),
                                                              ),
                                                            )
                                                          : ListView.builder(
                                                              itemCount: viewModel
                                                                  .hourMatches[
                                                                      index]
                                                                  .matches
                                                                  .length,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemBuilder:
                                                                  (context,
                                                                      indexMatch) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        defaultPadding /
                                                                            2,
                                                                  ),
                                                                  child:
                                                                      MatchCard(
                                                                    match: viewModel
                                                                        .hourMatches[
                                                                            index]
                                                                        .matches[indexMatch],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
