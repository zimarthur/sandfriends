import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import '../../../../../Common/Components/SFPieChartMobile.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/View/Mobile/SFStandardHeader.dart';
import '../../ViewModel/FinancesViewModel.dart';
import 'FinanceItem.dart';
import 'FinanceResume.dart';

class FinancesScreenMobile extends StatefulWidget {
  const FinancesScreenMobile({super.key});

  @override
  State<FinancesScreenMobile> createState() => FinancesScreenMobileState();
}

class FinancesScreenMobileState extends State<FinancesScreenMobile> {
  final FinancesViewModel viewModel = FinancesViewModel();
  bool isExpanded = false;

  @override
  void initState() {
    viewModel.initFinancesScreen(context);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FinancesViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<FinancesViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              children: [
                SFStandardHeader(
                  title: "Financeiro",
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
                      FinanceResume(
                        collapse: () => collapse(),
                        expand: () => expand(),
                        isExpanded: isExpanded,
                        onUpdatePlayerFilter: (newPlayer) =>
                            viewModel.updatePlayerFilter(newPlayer),
                        onUpdatePeriodVisualization: (newPeriod) => viewModel
                            .setPeriodVisualization(context, newPeriod),
                        periodVisualization: viewModel.periodVisualization,
                        revenueTitle: viewModel.revenueTitle,
                        revenuePrice: viewModel.revenue.formatPrice(
                          showRS: false,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                          ),
                          child: LayoutBuilder(
                              builder: (layoutContext, layoutConstraints) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: secondaryPaper,
                                      borderRadius: BorderRadius.circular(
                                        defaultBorderRadius,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: defaultPadding,
                                        vertical: defaultPadding / 2),
                                    height: 70,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              viewModel.expectedRevenueTitle,
                                              style: TextStyle(
                                                color: textDarkGrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: defaultPadding / 2,
                                        ),
                                        Text(
                                          "R\$",
                                          style: TextStyle(
                                            color: textLightGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          viewModel.expectedRevenue
                                              .formatPrice(showRS: false),
                                          style: TextStyle(
                                            color: textBlue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: defaultPadding,
                                  ),
                                  SizedBox(
                                    height: 120,
                                    child: SFPieChartMobile(
                                      title: "Modalidade",
                                      pieChartItems: viewModel.pieChartItems,
                                    ),
                                  ),
                                  SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Text(
                                    "Partidas",
                                    style: TextStyle(
                                      color: textDarkGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Container(
                                    height: layoutConstraints.maxHeight * 0.5,
                                    decoration: BoxDecoration(
                                      color: secondaryPaper,
                                      borderRadius: BorderRadius.circular(
                                        defaultBorderRadius,
                                      ),
                                    ),
                                    child: viewModel.matches.isEmpty
                                        ? Center(
                                            child: Text(
                                              "Sem partidas",
                                              style: TextStyle(
                                                color: textDarkGrey,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: viewModel.matches.length,
                                            itemBuilder: (context, index) {
                                              return FinanceItem(
                                                  match:
                                                      viewModel.matches[index]);
                                            },
                                          ),
                                  ),
                                ],
                              ),
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
