import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../Components/AvailableDaysResult/AvailableHourCard.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/CourtViewModel.dart';

class AvailableCourtsPrices extends StatefulWidget {
  double courtHeight;
  Color themeColor;
  CourtViewModel viewModel;
  bool showArrow;
  bool canScroll;
  AvailableCourtsPrices({
    required this.courtHeight,
    required this.themeColor,
    required this.viewModel,
    this.showArrow = false,
    required this.canScroll,
    super.key,
  });

  @override
  State<AvailableCourtsPrices> createState() => _AvailableCourtsPricesState();
}

class _AvailableCourtsPricesState extends State<AvailableCourtsPrices> {
  List<ScrollController> courtControllers = [];
  int jumpToPosition = 0;
  @override
  void initState() {
    if (widget.viewModel.courtAvailableHours.isNotEmpty) {
      for (int i = 0; i < widget.viewModel.courtAvailableHours.length; i++) {
        double initialOffset = 0;
        if (widget.viewModel.selectedCourt != null) {
          initialOffset =
              (widget.viewModel.courtAvailableHours[i].court.idStoreCourt ==
                      widget.viewModel.selectedCourt!.idStoreCourt)
                  ? (widget.viewModel.courtAvailableHours[i].hourPrices
                          .indexOf(widget.viewModel.selectedHourPrices.first) *
                      84)
                  : 0;
        }
        final scrollController =
            ScrollController(initialScrollOffset: initialOffset);

        courtControllers.add(scrollController);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: widget.canScroll ? null : NeverScrollableScrollPhysics(),
      itemCount: widget.viewModel.courtAvailableHours.length,
      itemBuilder: (context, indexcourt) {
        bool isSelectedCourt = widget.viewModel.selectedCourt == null
            ? false
            : widget.viewModel.selectedCourt!.idStoreCourt ==
                widget.viewModel.courtAvailableHours[indexcourt].court
                    .idStoreCourt;
        if (isSelectedCourt) {
          jumpToPosition = widget
              .viewModel.courtAvailableHours[indexcourt].hourPrices
              .indexOf(widget.viewModel.selectedHourPrices.first);
        }

        return SizedBox(
          height: widget.courtHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  bottom: defaultPadding / 4,
                  top: defaultPadding / 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.viewModel.courtAvailableHours[indexcourt].court
                          .description,
                      style: TextStyle(
                          color: widget.themeColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.viewModel.courtAvailableHours[indexcourt].court
                              .isIndoor
                          ? "Quadra Coberta"
                          : "Quadra Descoberta",
                      style: const TextStyle(color: textDarkGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child:
                    LayoutBuilder(builder: (layoutContext, layoutConstraints) {
                  return Row(
                    children: [
                      if (widget.showArrow)
                        InkWell(
                          onTap: () {
                            courtControllers[indexcourt].animateTo(
                              courtControllers[indexcourt].offset -
                                  layoutConstraints.maxWidth * 0.5,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          child: SvgPicture.asset(
                            r"assets/icon/arrow_left_triangle.svg",
                            height: 30,
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          controller: courtControllers[indexcourt],
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget
                              .viewModel
                              .courtAvailableHours[indexcourt]
                              .hourPrices
                              .length,
                          itemBuilder: ((context, indexHour) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: indexHour == 0 ? defaultPadding : 0),
                              child: AvailableHourCard(
                                hourPrice: widget
                                    .viewModel
                                    .courtAvailableHours[indexcourt]
                                    .hourPrices[indexHour],
                                isSelected: widget.viewModel.selectedHourPrices
                                        .contains(widget
                                            .viewModel
                                            .courtAvailableHours[indexcourt]
                                            .hourPrices[indexHour]) &&
                                    isSelectedCourt,
                                onTap: (a) => widget.viewModel.onTapHourPrice(
                                  widget.viewModel
                                      .courtAvailableHours[indexcourt].court,
                                  widget
                                      .viewModel
                                      .courtAvailableHours[indexcourt]
                                      .hourPrices[indexHour],
                                ),
                                isRecurrent: widget.viewModel.isRecurrent!,
                              ),
                            );
                          }),
                        ),
                      ),
                      if (widget.showArrow)
                        InkWell(
                          onTap: () => courtControllers[indexcourt].animateTo(
                            courtControllers[indexcourt].offset +
                                layoutConstraints.maxWidth * 0.5,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeIn,
                          ),
                          child: SvgPicture.asset(
                            r"assets/icon/arrow_right_triangle.svg",
                            height: 30,
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
