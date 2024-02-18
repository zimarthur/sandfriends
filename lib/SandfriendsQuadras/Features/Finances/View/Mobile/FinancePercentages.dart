import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import '../../../../../Common/Components/SFPieChart.dart';
import '../../../../../Common/Utils/Constants.dart';

class FinancePercentages extends StatelessWidget {
  double matchValue;
  int matchPercentage;
  double recurrentMatchValue;
  int recurrentMatchPercentage;
  List<PieChartItem> pieChartItems;
  FinancePercentages(
      {required this.matchValue,
      required this.matchPercentage,
      required this.recurrentMatchValue,
      required this.recurrentMatchPercentage,
      required this.pieChartItems,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Modalidade",
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: defaultBorderRadius,
                      width: defaultBorderRadius,
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(
                          4,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Avulso ($matchPercentage%)",
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          matchValue.formatPrice(),
                          style: TextStyle(
                            color: textLightGrey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultPadding / 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: defaultBorderRadius,
                      width: defaultBorderRadius,
                      decoration: BoxDecoration(
                        color: primaryLightBlue,
                        borderRadius: BorderRadius.circular(
                          4,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mensalista ($recurrentMatchPercentage%)",
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          recurrentMatchValue.formatPrice(),
                          style: TextStyle(
                            color: textLightGrey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          LayoutBuilder(builder: (layoutContext, layoutConstraints) {
            return SizedBox(
              height: layoutConstraints.maxHeight,
              width: layoutConstraints.maxHeight,
              child: SFPieChart(
                pieChartItems: pieChartItems,
              ),
            );
          }),
        ],
      ),
    );
  }
}
