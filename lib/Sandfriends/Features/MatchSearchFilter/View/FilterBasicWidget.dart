import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/Model/CustomFilter.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/View/OrderByItemWidget.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/ViewModel/MatchSearchFilterViewModel.dart';
import '../../../../../Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Common/Components/SportSelectorWidget.dart';

class FilterBasicWidget extends StatefulWidget {
  const FilterBasicWidget({super.key});

  @override
  State<FilterBasicWidget> createState() => _FilterBasicWidgetState();
}

class _FilterBasicWidgetState extends State<FilterBasicWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MatchSearchFilterViewModel>(context);
    Color primaryColor = viewModel.isRecurrent ? primaryLightBlue : primaryBlue;
    return Container(
      color: secondaryBack,
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Esporte",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  SportSelectorWidget(
                    selectedSport: viewModel.currentCustomFilter.sport,
                    onSelectedSport: (newSport) => viewModel.onChangeSport(
                      newSport,
                    ),
                    primaryColor: primaryColor,
                  ),
                  if (!viewModel.hideOrderBy)
                    Column(
                      children: [
                        SizedBox(
                          height: 3 * defaultPadding,
                        ),
                        Text(
                          "Ordenar por",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Container(
                          height: 110,
                          child: Row(
                            children: [
                              Expanded(
                                child: OrderByItemWidget(
                                  orderBy: OrderBy.distance,
                                  currentOrderBy:
                                      viewModel.currentCustomFilter.orderBy,
                                  icon: r"assets/icon/order_by_distance.svg",
                                  onNewOrderBy: (newOrderBy) => viewModel
                                      .onNewOrderBy(context, newOrderBy),
                                  primaryColor: primaryColor,
                                ),
                              ),
                              Expanded(
                                child: OrderByItemWidget(
                                    orderBy: OrderBy.price,
                                    currentOrderBy:
                                        viewModel.currentCustomFilter.orderBy,
                                    icon: r"assets/icon/order_by_price.svg",
                                    onNewOrderBy: (newOrderBy) => viewModel
                                        .onNewOrderBy(context, newOrderBy),
                                    primaryColor: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
