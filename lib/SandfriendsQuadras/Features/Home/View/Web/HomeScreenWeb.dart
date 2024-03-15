import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/ViewModel/StoreProvider.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'CourtOccupationWidget.dart';
import 'HomeKpi.dart';
import 'HomeMatchesWidget.dart';
import 'NotificationCard.dart';
import 'NotificationWidget.dart';
import 'OnboardingWidget.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  final HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    viewModel.initHomeScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (viewModel.needsOnboarding(context))
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: OnboardingWidget(viewModel: viewModel),
                  ),
                SizedBox(
                  height: height,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.welcomeTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Expanded(
                        child: LayoutBuilder(
                            builder: (layoutContext, layoutConstraints) {
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        if (Provider.of<StoreProvider>(context,
                                                listen: false)
                                            .isLoggedEmployeeAdmin())
                                          Expanded(
                                            child: HomeKpi(
                                              iconPath:
                                                  r"assets/icon/money.svg",
                                              iconColor: success,
                                              backgroundColor: success50,
                                              title:
                                                  "Previsão de faturamento hoje",
                                              value: viewModel.todaysProfit
                                                  .toInt(),
                                              lastValue: 400,
                                              isCurrency: true,
                                            ),
                                          ),
                                        if (Provider.of<StoreProvider>(context,
                                                listen: false)
                                            .isLoggedEmployeeAdmin())
                                          SizedBox(
                                            width: defaultPadding,
                                          ),
                                        Expanded(
                                          child: HomeKpi(
                                            iconPath: r"assets/icon/court.svg",
                                            iconColor: blueText,
                                            backgroundColor: blueBg,
                                            title: "Partidas hoje",
                                            value: viewModel.matches.length,
                                            lastValue: 400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: defaultPadding,
                                        ),
                                        Expanded(
                                          child: HomeKpi(
                                            iconPath: r"assets/icon/star.svg",
                                            iconColor: secondaryYellowDark,
                                            backgroundColor:
                                                secondaryYellowDark50,
                                            title:
                                                "Recompensas recolhidas hoje",
                                            value: viewModel.rewards.length,
                                            lastValue: 400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2 * defaultPadding,
                                    ),
                                    Expanded(
                                        child: Row(
                                      children: [
                                        SizedBox(
                                          width: 330,
                                          child: HomeMatchesWidget(
                                            viewModel: viewModel,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                defaultPadding),
                                            child: LayoutBuilder(
                                              builder: (layoutContext,
                                                  layoutConstraint) {
                                                double courtOccupationWidth =
                                                    layoutConstraint.maxWidth >
                                                            700
                                                        ? 700
                                                        : layoutConstraint
                                                            .maxWidth;
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          courtOccupationWidth,
                                                      child:
                                                          CourtOccupationWidget(
                                                        viewModel: viewModel,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: defaultPadding,
                              ),
                              SizedBox(
                                height: layoutConstraints.maxHeight,
                                width: 400,
                                child: NotificationWidget(
                                  notifications: viewModel.notifications,
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
