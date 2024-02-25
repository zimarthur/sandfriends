import 'package:flutter/material.dart';
import '../../../../../Common/Components/SFBarChart.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFCard.dart';
import '../../../../../Common/Components/SFHeader.dart';
import '../../../../../Common/Components/SFPeriodToggle.dart';
import '../../../../../Common/Components/SFPieChart.dart';
import '../../../../../Common/Components/Table/SFTable.dart';
import '../../../../../Common/Components/Table/SFTableHeader.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/RewardsViewModel.dart';

class RewardsScreenWeb extends StatefulWidget {
  const RewardsScreenWeb({super.key});

  @override
  State<RewardsScreenWeb> createState() => _RewardsScreenWebState();
}

class _RewardsScreenWebState extends State<RewardsScreenWeb> {
  final RewardsViewModel viewModel = RewardsViewModel();

  @override
  void initState() {
    viewModel.initRewardsScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return ChangeNotifierProvider<RewardsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<RewardsViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: SFHeader(
                        header: "Recompensas",
                        description:
                            "Confira as recompensas que os jogadores já retiraram no seu estabelecimento!"),
                  ),
                  SFButton(
                    buttonLabel: "Adic. Recompensa",
                    onTap: () {
                      viewModel.addReward(context);
                    },
                    iconFirst: true,
                    iconPath: r"assets/icon/plus.svg",
                    textPadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: defaultPadding * 2,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SFPeriodToggle(
                currentPeriodVisualization: viewModel.periodVisualization,
                onChanged: (newPeriod) =>
                    viewModel.setPeriodVisualization(context, newPeriod),
                customText: viewModel.customDateTitle,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                height: 60,
                constraints: const BoxConstraints(minHeight: 60),
                child: Row(
                  children: [
                    const Text(
                      "Recompensas recolhidas:",
                      style: TextStyle(color: textDarkGrey),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    Text(
                      "${viewModel.rewardsCounter}",
                      textScaleFactor: 1.5,
                      style: const TextStyle(
                          color: textBlue, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double remainingHeight = height - 200;
                    final double widgetHeight =
                        constraints.maxHeight < remainingHeight
                            ? constraints.maxHeight
                            : remainingHeight;
                    return SizedBox(
                      height: widgetHeight,
                      child: Row(
                        children: [
                          SFTable(
                            height: widgetHeight,
                            width: width * 0.5,
                            headers: [
                              SFTableHeader("date", "Data"),
                              SFTableHeader("hour", "Hora"),
                              SFTableHeader("player", "Jogador"),
                              SFTableHeader("reward", "Recompensa"),
                            ],
                            source: viewModel.rewardsDataSource!,
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Column(
                            children: [
                              SFCard(
                                height: (widgetHeight - defaultPadding) / 2,
                                width: width * 0.5 - defaultPadding,
                                title: "Recompensas mais recolhidas",
                                child: SFPieChart(
                                  pieChartItems: viewModel.pieChartItems,
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              SFCard(
                                height: (widgetHeight - defaultPadding) / 2,
                                width: width * 0.5 - defaultPadding,
                                title: "Recompensas recolhidas por data",
                                child: SFBarChart(
                                  barChartItems: viewModel.barChartItems,
                                  barChartVisualization:
                                      viewModel.periodVisualization,
                                  customStartDate: viewModel.customStartDate,
                                  customEndDate: viewModel.customEndDate,
                                ),
                              ),
                            ],
                          ),
                        ],
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
