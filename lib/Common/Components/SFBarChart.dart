import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'dart:math' as math;

import '../Enum/EnumPeriodVisualization.dart';
import '../Model/SandfriendsQuadras/SFBarChartItem.dart';
import '../Utils/Constants.dart';
import '../Utils/SFDateTime.dart';

class SFBarChart extends StatefulWidget {
  List<SFBarChartItem> barChartItems;
  EnumPeriodVisualization barChartVisualization;
  DateTime? customStartDate;
  DateTime? customEndDate;
  bool showCurrency;
  SFBarChart({
    required this.barChartItems,
    required this.barChartVisualization,
    this.customStartDate,
    this.customEndDate,
    this.showCurrency = false,
  });

  @override
  State<SFBarChart> createState() => _SFBarChartState();
}

class _SFBarChartState extends State<SFBarChart> {
  late BarChartData data;
  late Function(double) axisXLabel;
  late Function(int) toolTipLabel;
  List<BarChartGroupData> chartData = [];

  @override
  Widget build(BuildContext context) {
    //axisXLabel = (value) => value.toString();
    switch (widget.barChartVisualization) {
      case EnumPeriodVisualization.Today:
        chartData = dayData(widget.barChartItems);
        toolTipLabel = (value) => '$value:00\n';
        break;
      case EnumPeriodVisualization.CurrentMonth:
        chartData = monthData(widget.barChartItems);
        toolTipLabel = (value) =>
            '$value ${monthsPortuguese[getSFMonthIndex(DateTime.now())]}\n';
        break;
      case EnumPeriodVisualization.Custom:
        if (widget.customEndDate == null ||
            areInTheSameDay(widget.customStartDate!, widget.customEndDate!)) {
          chartData = dayData(widget.barChartItems);
          toolTipLabel = (value) => '$value:00\n';
        } else if (areInTheSameMonth(
            widget.customStartDate!, widget.customEndDate!)) {
          chartData = monthData(widget.barChartItems);
          toolTipLabel = (value) =>
              '$value ${monthsPortuguese[getSFMonthIndex(widget.customStartDate!)]}\n';
        } else {
          chartData = [];
          List<String> monthsAxis = [];
          widget.barChartItems.sort((a, b) => b.date.compareTo(a.date));

          final groupByMonth = groupBy(
              widget.barChartItems,
              (SFBarChartItem barChartItem) =>
                  DateTime(barChartItem.date.year, barChartItem.date.month));
          final itemsByMonth = groupByMonth.map((key, value) => MapEntry(
              key,
              value.fold(0,
                  (previousValue, element) => previousValue + element.amount)));

          itemsByMonth.forEach((key, value) {
            chartData.add(standardChartDate(
                itemsByMonth.keys.toList().indexOf(key), value));

            monthsAxis.add(getMonthYear(key));
          });
          axisXLabel = (value) => monthsAxis[value.toInt()];
          toolTipLabel = (value) => '${monthsAxis[value.toInt()]}\n';
        }
    }

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                toolTipLabel(group.x),
                const TextStyle(
                  color: textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.showCurrency ? "R\$ ${rod.toY}" : "${rod.toY}",
                    style: const TextStyle(
                      color: primaryLightBlue,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          // Add your x axis labels here
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final Widget text = Transform.rotate(
                  angle: -math.pi / 3,
                  child: Text(
                    toolTipLabel(value.toInt()),
                    style: const TextStyle(
                      color: textDarkGrey,
                    ),
                  ),
                );

                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 16, //margin top
                  child: text,
                );
              },
              reservedSize: 42,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        borderData: FlBorderData(
            border: const Border(
          top: BorderSide.none,
          right: BorderSide.none,
          left: BorderSide.none,
          bottom: BorderSide(width: 1),
        )),
        groupsSpace: 10,
        barGroups: chartData,
      ),
    );
  }
}

BarChartGroupData standardChartDate(int x, int y) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y.toDouble(),
        width: 15,
        color: primaryBlue,
      ),
    ],
  );
}

List<BarChartGroupData> dayData(List<SFBarChartItem> barChartItems) {
  List<BarChartGroupData> chartData = [];
  for (int hourIndex = 1; hourIndex < 25; hourIndex++) {
    int itemCounter = 0;
    for (var barChartItem in barChartItems) {
      if (areInTheSameDay(barChartItem.date, DateTime.now()) &&
          barChartItem.date.hour == hourIndex) {
        itemCounter += barChartItem.amount;
      }
    }
    chartData.add(standardChartDate(hourIndex, itemCounter));
  }
  return chartData;
}

List<BarChartGroupData> monthData(List<SFBarChartItem> barChartItems) {
  List<BarChartGroupData> chartData = [];
  for (int dayIndex = 1;
      dayIndex < lastDayOfMonth(DateTime.now()).day;
      dayIndex++) {
    int itemCounter = 0;
    for (var barChartItem in barChartItems) {
      if (areInTheSameDay(barChartItem.date,
          DateTime(DateTime.now().year, DateTime.now().month, dayIndex))) {
        itemCounter += barChartItem.amount;
      }
    }
    chartData.add(standardChartDate(dayIndex, itemCounter));
  }
  return chartData;
}
