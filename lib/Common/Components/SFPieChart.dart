import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'dart:math' as math;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../Utils/Constants.dart';
import '../Utils/Responsive.dart';

class SFPieChart extends StatefulWidget {
  List<PieChartItem> pieChartItems;
  String? title;
  bool labelsFirst;

  SFPieChart({
    super.key,
    required this.pieChartItems,
    this.title,
    this.labelsFirst = false,
  });

  @override
  State<SFPieChart> createState() => _SFPieChartState();
}

class _SFPieChartState extends State<SFPieChart> {
  int touchedIndex = -1;
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    double chartValuesSum =
        widget.pieChartItems.fold(0, (sum, item) => sum + item.value);
    if (widget.pieChartItems.any((element) => element.color == null)) {
      for (int i = 0; i < widget.pieChartItems.length; i++) {
        if (i < sfColors.length) {
          widget.pieChartItems[i].color = sfColors[i];
        } else {
          widget.pieChartItems[i].color =
              Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0);
        }
      }
    }

    return widget.pieChartItems.isEmpty
        ? Container()
        : LayoutBuilder(
            builder: (layoutContext, layoutConstraints) {
              return Row(
                textDirection: widget.labelsFirst ? TextDirection.rtl : null,
                children: [
                  SizedBox(
                    height: layoutConstraints.maxHeight,
                    width: layoutConstraints.maxHeight,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: layoutConstraints.maxHeight * 0.1,
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              } else {
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                                if (touchedIndex >= 0) {
                                  _scrollController.scrollTo(
                                      index: touchedIndex,
                                      duration:
                                          const Duration(milliseconds: 150));
                                }
                              }
                            });
                          },
                        ),
                        sections: <PieChartSectionData>[
                          for (int i = 0; i < widget.pieChartItems.length; i++)
                            PieChartSectionData(
                              titleStyle: TextStyle(
                                color: textWhite,
                                fontSize:
                                    Responsive.isMobile(context) ? 10 : null,
                              ),
                              title:
                                  "${(widget.pieChartItems[i].value * 100 / chartValuesSum).toStringAsFixed(0)}%",
                              value: widget.pieChartItems[i].value,
                              color: widget.pieChartItems[i].color,
                              radius: i == touchedIndex
                                  ? layoutConstraints.maxHeight * 0.4
                                  : layoutConstraints.maxHeight * 0.3,
                            ),
                        ],
                      ),
                      swapAnimationDuration:
                          const Duration(milliseconds: 150), // Optional
                      swapAnimationCurve: Curves.linear, // Optional
                    ),
                  ),
                  SizedBox(
                    width: widget.labelsFirst ? 0 : defaultPadding * 2,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: defaultPadding / 2),
                            child: Text(
                              widget.title!,
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                          ),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _scrollController,
                            itemCount: widget.pieChartItems.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: defaultPadding,
                                    width: defaultPadding,
                                    decoration: BoxDecoration(
                                      color: widget.pieChartItems[index].color,
                                      borderRadius: BorderRadius.circular(
                                        4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.pieChartItems[index].name} (${(widget.pieChartItems[index].value * 100 / chartValuesSum).toStringAsFixed(0)}%)",
                                        style: TextStyle(
                                          color: touchedIndex == index
                                              ? widget
                                                  .pieChartItems[index].color
                                              : textDarkGrey,
                                          fontSize: 12,
                                          fontWeight: touchedIndex == index
                                              ? FontWeight.bold
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        widget.pieChartItems[index].isPrice
                                            ? widget.pieChartItems[index].value
                                                .formatPrice()
                                            : widget.pieChartItems[index].value
                                                .toStringAsFixed(0),
                                        style: TextStyle(
                                          color: textLightGrey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
  }
}

class PieChartItem {
  String name;
  double value;
  Color? color;
  bool isPrice;

  PieChartItem(
      {required this.name,
      required this.value,
      this.isPrice = false,
      this.color});
}
