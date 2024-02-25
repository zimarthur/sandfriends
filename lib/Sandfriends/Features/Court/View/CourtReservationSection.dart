import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/Court/View/DayFilter.dart';
import 'package:sandfriends/Sandfriends/Features/Court/View/SportFilter.dart';
import 'package:sandfriends/Sandfriends/Features/Court/ViewModel/CourtViewModel.dart';
import 'package:sandfriends/Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Common/Components/AvailableDaysResult/AvailableHourCard.dart';
import '../../../../Common/Components/SFLoading.dart';
import '../../../../Common/Utils/SFDateTime.dart';

class CourtReservationSection extends StatefulWidget {
  CourtViewModel viewModel;
  final Color themeColor;
  CourtReservationSection({
    required this.viewModel,
    required this.themeColor,
    super.key,
  });

  @override
  State<CourtReservationSection> createState() =>
      _CourtReservationSectionState();
}

class _CourtReservationSectionState extends State<CourtReservationSection> {
  bool isExpanded = true;
  Duration duration = Duration(milliseconds: 200);
  double dateFilterHeight = 50;
  double courtHeigth = 120;
  ScrollController selectedScrollController = ScrollController();
  int jumpToPosition = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.viewModel.courtAvailableHours.isNotEmpty) {
        selectedScrollController.animateTo(
          jumpToPosition * 84,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          color: textLightGrey,
          margin: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.02),
          height: 1,
        ),
        AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(
              color: widget.themeColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  defaultBorderRadius,
                ),
                topRight: Radius.circular(
                  defaultBorderRadius,
                ),
                bottomLeft: Radius.circular(
                  isExpanded ? 0 : defaultBorderRadius,
                ),
                bottomRight: Radius.circular(
                  isExpanded ? 0 : defaultBorderRadius,
                ),
              )),
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding / 2,
            horizontal: defaultPadding,
          ),
          child: InkWell(
            onTap: () => setState(() {
              isExpanded = !isExpanded;
            }),
            child: Row(
              children: [
                SvgPicture.asset(
                  r"assets/icon/calendar.svg",
                  color: textWhite,
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  "Agende seu horário",
                  style: TextStyle(
                      color: textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Expanded(
                  child: Container(),
                ),
                AnimatedRotation(
                  duration: duration,
                  turns: isExpanded ? 0.5 : 0,
                  child: SvgPicture.asset(
                    r"assets/icon/chevron_down.svg",
                    color: textWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
              border: Border.all(color: divider),
              boxShadow: [
                if (isExpanded)
                  BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                    color: divider,
                  )
              ],
              color: secondaryPaper,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  defaultBorderRadius,
                ),
                bottomRight: Radius.circular(
                  defaultBorderRadius,
                ),
              ),
            ),
            width: double.infinity,
            height: isExpanded
                ? widget.viewModel.courtAvailableHours.isEmpty
                    ? courtHeigth + dateFilterHeight
                    : (courtHeigth *
                                widget.viewModel.courtAvailableHours.length)
                            .toDouble() +
                        dateFilterHeight +
                        (2.5 * defaultPadding) +
                        2 //border
                : 0,
            child: widget.viewModel.isLoading
                ? SFLoading()
                : isExpanded
                    ? Column(
                        children: [
                          SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: dateFilterHeight,
                                    child: DayFilter(
                                      date: widget.viewModel.selectedDate,
                                      weekDay: widget.viewModel.selectedWeekday,
                                      onYesterday: () =>
                                          widget.viewModel.onYesterday(context),
                                      onTomorrow: () =>
                                          widget.viewModel.onTomorrow(context),
                                      themeColor: widget.themeColor,
                                      onOpenDateModal: () => widget.viewModel
                                          .openDateSelectorModal(context),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Container(
                                  height: dateFilterHeight,
                                  child: SportFilter(
                                      availableSports:
                                          Provider.of<CategoriesProvider>(
                                                  context,
                                                  listen: false)
                                              .sports,
                                      onSelectedSport: (sport) =>
                                          widget.viewModel.setSport(
                                            context,
                                            sport,
                                          ),
                                      selectedSport:
                                          widget.viewModel.selectedSport!),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          widget.viewModel.courtAvailableHours.isEmpty
                              ? const Expanded(
                                  child: Center(
                                    child: Text(
                                      "Nenhum horário encontrado",
                                      style: TextStyle(color: textDarkGrey),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget
                                      .viewModel.courtAvailableHours.length,
                                  itemBuilder: (context, indexcourt) {
                                    bool isSelectedCourt = widget
                                                .viewModel.selectedCourt ==
                                            null
                                        ? false
                                        : widget.viewModel.selectedCourt!
                                                .idStoreCourt ==
                                            widget
                                                .viewModel
                                                .courtAvailableHours[indexcourt]
                                                .court
                                                .idStoreCourt;
                                    if (isSelectedCourt) {
                                      jumpToPosition = widget
                                          .viewModel
                                          .courtAvailableHours[indexcourt]
                                          .hourPrices
                                          .indexOf(widget.viewModel
                                              .selectedHourPrices.first);
                                    }

                                    return Container(
                                      height: courtHeigth,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: defaultPadding,
                                              bottom: defaultPadding / 4,
                                              top: defaultPadding / 4,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget
                                                      .viewModel
                                                      .courtAvailableHours[
                                                          indexcourt]
                                                      .court
                                                      .description,
                                                  style: TextStyle(
                                                      color: widget.themeColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  widget
                                                          .viewModel
                                                          .courtAvailableHours[
                                                              indexcourt]
                                                          .court
                                                          .isIndoor
                                                      ? "Quadra Coberta"
                                                      : "Quadra Descoberta",
                                                  style: const TextStyle(
                                                      color: textDarkGrey,
                                                      fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              controller: isSelectedCourt
                                                  ? selectedScrollController
                                                  : null,
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: widget
                                                  .viewModel
                                                  .courtAvailableHours[
                                                      indexcourt]
                                                  .hourPrices
                                                  .length,
                                              itemBuilder:
                                                  ((context, indexHour) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: indexHour == 0
                                                          ? defaultPadding
                                                          : 0),
                                                  child: AvailableHourCard(
                                                    hourPrice: widget
                                                        .viewModel
                                                        .courtAvailableHours[
                                                            indexcourt]
                                                        .hourPrices[indexHour],
                                                    isSelected: widget.viewModel
                                                            .selectedHourPrices
                                                            .contains(widget
                                                                    .viewModel
                                                                    .courtAvailableHours[
                                                                        indexcourt]
                                                                    .hourPrices[
                                                                indexHour]) &&
                                                        isSelectedCourt,
                                                    onTap: (a) => widget
                                                        .viewModel
                                                        .onTapHourPrice(
                                                      widget
                                                          .viewModel
                                                          .courtAvailableHours[
                                                              indexcourt]
                                                          .court,
                                                      widget
                                                          .viewModel
                                                          .courtAvailableHours[
                                                              indexcourt]
                                                          .hourPrices[indexHour],
                                                    ),
                                                    isRecurrent: widget
                                                        .viewModel.isRecurrent!,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                        ],
                      )
                    : Container()),
      ],
    );
  }
}
