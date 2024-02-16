import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/Model/EnumPeriodVisualization.dart';

import '../../../../Utils/Constants.dart';
import '../../../Rewards/View/Mobile/PlayerCalendarFilter.dart';

class FinanceResume extends StatefulWidget {
  VoidCallback collapse;
  VoidCallback expand;
  bool isExpanded;
  Function(String) onUpdatePlayerFilter;
  EnumPeriodVisualization periodVisualization;
  Function(EnumPeriodVisualization) onUpdatePeriodVisualization;
  String revenueTitle;
  String revenuePrice;
  FinanceResume(
      {required this.collapse,
      required this.expand,
      required this.isExpanded,
      required this.onUpdatePlayerFilter,
      required this.periodVisualization,
      required this.onUpdatePeriodVisualization,
      required this.revenueTitle,
      required this.revenuePrice,
      super.key});

  @override
  State<FinanceResume> createState() => _FinanceResumeState();
}

class _FinanceResumeState extends State<FinanceResume> {
  final playerController = TextEditingController();

  @override
  void initState() {
    playerController.addListener(() {
      widget.onUpdatePlayerFilter(playerController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    playerController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (drag) {
        if (drag.delta.dy < -5.0) {
          widget.collapse();
        } else if (drag.delta.dy > 5.0) {
          widget.expand();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: widget.isExpanded ? 170 : 120,
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              defaultBorderRadius,
            ),
            bottomRight: Radius.circular(
              defaultBorderRadius,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                      duration: Duration(milliseconds: 200),
                      child: widget.isExpanded
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: defaultPadding),
                              child: PlayerCalendarFilter(
                                playerController: playerController,
                                onSelectedPeriod: (newPeriod) => widget
                                    .onUpdatePeriodVisualization(newPeriod),
                                selectedPeriod: widget.periodVisualization,
                              ),
                            )
                          : Container()),
                  Flexible(
                    child: Text(
                      widget.revenueTitle,
                      style: TextStyle(
                        color: textWhite,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Text(
                          "R\$",
                          style: TextStyle(
                            color: textLightGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          widget.revenuePrice,
                          style: TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Container(
              width: 50,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: defaultPadding / 2),
              decoration: BoxDecoration(
                  color: secondaryPaper,
                  borderRadius: BorderRadius.circular(defaultPadding)),
            ),
          ],
        ),
      ),
    );
  }
}
