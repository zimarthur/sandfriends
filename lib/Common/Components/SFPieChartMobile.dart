import 'package:flutter/material.dart';
import '../Utils/Constants.dart';
import 'SFPieChart.dart';

class SFPieChartMobile extends StatelessWidget {
  String? title;
  List<PieChartItem> pieChartItems;
  SFPieChartMobile({this.title, required this.pieChartItems, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, layoutConstraints) {
      return Container(
          height: layoutConstraints.maxHeight,
          decoration: BoxDecoration(
            color: secondaryPaper,
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          child: SFPieChart(
            pieChartItems: pieChartItems,
            title: title,
            labelsFirst: true,
          ));
    });
  }
}
