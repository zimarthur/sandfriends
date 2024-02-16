import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Features/Finances/View/Mobile/FinanceItem.dart';
import 'package:sandfriends_web/Features/Finances/View/Mobile/FinancePercentages.dart';
import 'package:sandfriends_web/Features/Finances/View/Mobile/FinanceResume.dart';
import 'package:sandfriends_web/Features/Finances/ViewModel/FinancesViewModel.dart';
import 'package:sandfriends_web/Features/Players/View/Mobile/PlayerItem.dart';
import 'package:sandfriends_web/Features/Players/View/Mobile/PlayersResume.dart';
import 'package:sandfriends_web/Features/Players/ViewModel/PlayersViewModel.dart';
import 'package:sandfriends_web/Features/Rewards/View/Mobile/PlayerCalendarFilter.dart';
import 'package:sandfriends_web/SharedComponents/Model/EnumPeriodVisualization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends_web/SharedComponents/View/SFPieChartMobile.dart';
import 'package:sandfriends_web/Utils/TypesExtensions.dart';
import '../../../../SharedComponents/View/SFPieChart.dart';
import '../../../../Utils/Constants.dart';
import '../../../Menu/View/Mobile/SFStandardHeader.dart';

class PlayersScreenMobile extends StatefulWidget {
  const PlayersScreenMobile({super.key});

  @override
  State<PlayersScreenMobile> createState() => PlayersScreenMobileState();
}

class PlayersScreenMobileState extends State<PlayersScreenMobile> {
  final PlayersViewModel viewModel = PlayersViewModel();
  final scrollController = ScrollController();
  int indexPieChart = 0;
  bool isExpanded = false;

  @override
  void initState() {
    viewModel.initViewModel(context);
    scrollController.addListener(() {
      setState(() {
        indexPieChart = (scrollController.offset /
                scrollController.position.viewportDimension)
            .floor();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void expand() {
    setState(() {
      isExpanded = true;
    });
  }

  void collapse() {
    setState(() {
      isExpanded = false;
    });
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  double plusButtonHeight = 70;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayersViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<PlayersViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              children: [
                SFStandardHeader(
                  title: "Jogadores",
                  leftWidget: InkWell(
                    onTap: () => toggleExpand(),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        margin: const EdgeInsets.only(left: defaultPadding / 2),
                        child: SvgPicture.asset(
                          r"assets/icon/search.svg",
                          color: textWhite,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      PlayersResume(
                        collapse: () => collapse(),
                        expand: () => expand(),
                        isExpanded: isExpanded,
                        playerController: viewModel.nameFilterController,
                        onUpdatePlayerFilter: (newPlayer) =>
                            viewModel.filterName(context),
                        playersQuantity: viewModel.players.length.toString(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                          ),
                          child: LayoutBuilder(
                              builder: (layoutContext, layoutConstraints) {
                            return Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      Text(
                                        "Conheça seus jogadores",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: defaultPadding,
                                      ),

                                      SizedBox(
                                        height: 120,
                                        child: LayoutBuilder(
                                          builder: (_, layoutConstraints) {
                                            return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  viewModel.pieChartKpis.length,
                                              physics: PageScrollPhysics(),
                                              controller: scrollController,
                                              itemBuilder: (context, index) {
                                                return SizedBox(
                                                  height: layoutConstraints
                                                      .maxHeight,
                                                  width: layoutConstraints
                                                      .maxWidth,
                                                  child: SFPieChartMobile(
                                                    pieChartItems: viewModel
                                                        .pieChartKpis[index]
                                                        .pieChartitems,
                                                    title: viewModel
                                                        .pieChartKpis[index]
                                                        .title,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: defaultPadding,
                                        padding: EdgeInsets.only(
                                            top: defaultPadding / 2),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                viewModel.pieChartKpis.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (_, index) {
                                              return Container(
                                                height: defaultPadding,
                                                width: defaultPadding,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: index == indexPieChart
                                                      ? textBlue
                                                      : divider,
                                                ),
                                              );
                                            }),
                                      ),
                                      // FinancePercentages(
                                      //   matchValue: viewModel.revenueFromMatch,
                                      //   matchPercentage:
                                      //       viewModel.revenueFromMatchPercentage,
                                      //   recurrentMatchValue:
                                      //       viewModel.revenueFromRecurrentMatch,
                                      //   recurrentMatchPercentage: viewModel
                                      //       .revenueFromRecurrentMatchPercentage,
                                      //   pieChartItems: viewModel.pieChartItems,
                                      // ),
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      Text(
                                        "Jogadores",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: defaultPadding / 2,
                                      ),
                                      Container(
                                        height:
                                            layoutConstraints.maxHeight * 0.5,
                                        decoration: BoxDecoration(
                                          color: secondaryPaper,
                                          borderRadius: BorderRadius.circular(
                                            defaultBorderRadius,
                                          ),
                                        ),
                                        child: viewModel.players.isEmpty
                                            ? Center(
                                                child: Text(
                                                  "Sem jogadores",
                                                  style: TextStyle(
                                                    color: textDarkGrey,
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount:
                                                    viewModel.players.length,
                                                itemBuilder: (context, index) {
                                                  return PlayerItem(
                                                    openWhatsApp: ()=>viewModel.openWhatsApp(context, viewModel
                                                          .players[index]),
                                                      player: viewModel
                                                          .players[index]);
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: (layoutConstraints.maxWidth -
                                          plusButtonHeight) /
                                      2,
                                  child: InkWell(
                                    onTap: () => viewModel
                                        .openStorePlayerWidget(context, null),
                                    child: Container(
                                      width: plusButtonHeight,
                                      height: plusButtonHeight,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: blueText),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          r"assets/icon/plus.svg",
                                          height: 30,
                                          color: blueBg,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
