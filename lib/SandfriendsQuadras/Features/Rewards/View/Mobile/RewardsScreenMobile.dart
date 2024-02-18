import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/View/Mobile/SFStandardHeader.dart';
import '../../ViewModel/RewardsViewModel.dart';
import 'PlayerCalendarFilter.dart';
import 'RewardUserItem.dart';

class RewardsScreenMobile extends StatefulWidget {
  const RewardsScreenMobile({super.key});

  @override
  State<RewardsScreenMobile> createState() => _RewardsScreenMobileState();
}

class _RewardsScreenMobileState extends State<RewardsScreenMobile> {
  final RewardsViewModel viewModel = RewardsViewModel();
  final playerController = TextEditingController();
  @override
  void initState() {
    viewModel.initRewardsScreen(context);
    playerController.addListener(() {
      viewModel.updatePlayerFilter(playerController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    playerController.removeListener(() {});
    super.dispose();
  }

  double plusButtonHeight = 70;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewardsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<RewardsViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              children: [
                SFStandardHeader(
                  title: "Recompensas",
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: defaultPadding / 2,
                        horizontal: defaultPadding / 2),
                    child: LayoutBuilder(
                        builder: (layoutContext, layoutConstraints) {
                      return Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PlayerCalendarFilter(
                                playerController: playerController,
                                onSelectedPeriod: (newPeriod) => viewModel
                                    .setPeriodVisualization(context, newPeriod),
                                selectedPeriod: viewModel.periodVisualization,
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Container(
                                height: 80,
                                padding: EdgeInsets.all(defaultPadding),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    defaultBorderRadius,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      secondaryYellowDark,
                                      secondaryYellowDark,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        viewModel.rewardsPeriodTitle,
                                        style: TextStyle(
                                          color: secondaryYellowDark50,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: defaultPadding,
                                    ),
                                    Text(
                                      viewModel.rewardsCounter.toString(),
                                      style: TextStyle(
                                        color: secondaryYellowDark50,
                                        fontSize: 24,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Text(
                                "Recompensas",
                                style: TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding / 2,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: secondaryPaper,
                                    borderRadius: BorderRadius.circular(
                                      defaultBorderRadius,
                                    ),
                                  ),
                                  child: viewModel.rewards.isEmpty
                                      ? Center(
                                          child: Text(
                                            "Sem recompensas",
                                            style: TextStyle(
                                              color: textDarkGrey,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: viewModel.rewards.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: index ==
                                                          viewModel.rewards
                                                                  .length -
                                                              1
                                                      ? plusButtonHeight
                                                      : 0),
                                              child: RewardUserItem(
                                                reward:
                                                    viewModel.rewards[index],
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding / 2,
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            left: (layoutConstraints.maxWidth -
                                    plusButtonHeight) /
                                2,
                            child: InkWell(
                              onTap: () => viewModel.addReward(context),
                              child: Container(
                                width: plusButtonHeight,
                                height: plusButtonHeight,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: secondaryYellowDark),
                                child: Center(
                                  child: SvgPicture.asset(
                                    r"assets/icon/plus.svg",
                                    height: 30,
                                    color: secondaryYellowDark50,
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
          );
        },
      ),
    );
  }
}
