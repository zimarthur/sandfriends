import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Utils/SFDateTime.dart';

import '../../../Utils/Constants.dart';
import '../../../SharedComponents/View/AvailableDaysResult/AvailableHourCard.dart';
import '../ViewModel/CourtViewModel.dart';

class CourtAvailableCourts extends StatefulWidget {
  final CourtViewModel viewModel;
  final Color themeColor;
  const CourtAvailableCourts({
    Key? key,
    required this.viewModel,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<CourtAvailableCourts> createState() => _CourtAvailableCourtsState();
}

class _CourtAvailableCourtsState extends State<CourtAvailableCourts> {
  ScrollController selectedScrollController = ScrollController();
  int jumpToPosition = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedScrollController.animateTo(
        jumpToPosition * 84,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: textLightGrey,
            margin: EdgeInsets.symmetric(
                vertical: height * 0.02, horizontal: width * 0.02),
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Row(
              children: [
                SvgPicture.asset(
                  r'assets/icon/calendar.svg',
                  color: widget.themeColor,
                ),
                Padding(padding: EdgeInsets.only(right: width * 0.01)),
                Text(
                  widget.viewModel.isRecurrent!
                      ? "${weekDaysPortuguese[widget.viewModel.selectedWeekday!]} - Mensalista"
                      : DateFormat("dd/MM/yyyy")
                          .format(widget.viewModel.selectedDate!),
                  style: TextStyle(
                    color: widget.themeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Text(
              widget.viewModel.courtAvailableHours.length > 1
                  ? "Selecione a quadra e a duração do jogo"
                  : "Selecione a duração do jogo",
              style: const TextStyle(
                  color: textDarkGrey, fontWeight: FontWeight.w700),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.viewModel.courtAvailableHours.length,
            itemBuilder: (context, indexcourt) {
              bool isSelectedCourt =
                  widget.viewModel.selectedCourt!.idStoreCourt ==
                      widget.viewModel.courtAvailableHours[indexcourt].court
                          .idStoreCourt;
              if (isSelectedCourt) {
                jumpToPosition = widget
                    .viewModel.courtAvailableHours[indexcourt].hourPrices
                    .indexOf(widget.viewModel.selectedHourPrices.first);
              }

              return Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.02,
                        bottom: width * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.viewModel.courtAvailableHours[indexcourt]
                                .court.storeCourtName,
                            style: TextStyle(
                              color: widget.themeColor,
                            ),
                          ),
                          Text(
                            widget.viewModel.courtAvailableHours[indexcourt]
                                    .court.isIndoor
                                ? "Quadra Coberta"
                                : "Quadra Descoberta",
                            textScaleFactor: 0.8,
                            style: const TextStyle(color: textDarkGrey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        controller:
                            isSelectedCourt ? selectedScrollController : null,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.viewModel
                            .courtAvailableHours[indexcourt].hourPrices.length,
                        itemBuilder: ((context, indexHour) {
                          return AvailableHourCard(
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
                              widget.viewModel.courtAvailableHours[indexcourt]
                                  .court,
                              widget.viewModel.courtAvailableHours[indexcourt]
                                  .hourPrices[indexHour],
                            ),
                            isRecurrent: widget.viewModel.isRecurrent!,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
