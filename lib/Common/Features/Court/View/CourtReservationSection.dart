import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/Court/View/AvailableCourtsPrices.dart';
import 'package:sandfriends/Common/Features/Court/View/DayFilter.dart';
import 'package:sandfriends/Common/Features/Court/View/SportFilter.dart';
import 'package:sandfriends/Common/Features/Court/ViewModel/CourtViewModel.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../Components/AvailableDaysResult/AvailableHourCard.dart';
import '../../../Components/SFLoading.dart';
import '../../../Utils/SFDateTime.dart';

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
  double courtHeight = 120;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: defaultPadding * 2,
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
                    ? courtHeight + dateFilterHeight
                    : (courtHeight *
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
                              : AvailableCourtsPrices(
                                  courtHeight: courtHeight,
                                  themeColor: widget.themeColor,
                                  viewModel: widget.viewModel,
                                  canScroll: false,
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
