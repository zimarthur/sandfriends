import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:time_range/time_range.dart';

import '../../../../Common/Model/City.dart';
import '../../../../Common/Components/SFButton.dart';

import 'SFSearchFilter.dart';

class MatchSearchFilters extends StatefulWidget {
  final City? city;
  final VoidCallback openCitySelector;
  final List<DateTime?>? dates;
  final List<int>? days;
  final VoidCallback openDateSelector;
  final TimeRangeResult? time;
  final VoidCallback openTimeSelector;
  final VoidCallback onTapSearch;
  final Color primaryColor;

  const MatchSearchFilters({
    Key? key,
    required this.city,
    required this.openCitySelector,
    this.dates,
    this.days,
    required this.openDateSelector,
    required this.time,
    required this.openTimeSelector,
    required this.onTapSearch,
    required this.primaryColor,
  }) : super(key: key);

  @override
  State<MatchSearchFilters> createState() => _MatchSearchFiltersState();
}

class _MatchSearchFiltersState extends State<MatchSearchFilters> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: widget.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        children: [
          SFSearchFilter(
            labelText: widget.city == null
                ? "Cidade"
                : "${widget.city!.name} - ${widget.city!.state!.uf}",
            iconPath: r"assets/icon/location_ping.svg",
            onTap: widget.openCitySelector,
          ),
          Row(
            children: [
              Expanded(
                  child: widget.dates != null
                      ? SFSearchFilter(
                          labelText: widget.dates!.isEmpty
                              ? "Data"
                              : widget.dates!.length == 1
                                  ? "${widget.dates![0]!.day.toString().padLeft(2, '0')}/${widget.dates![0]!.month.toString().padLeft(2, '0')}"
                                  : "${widget.dates![0]!.day.toString().padLeft(2, '0')}/${widget.dates![0]!.month.toString().padLeft(2, '0')} - ${widget.dates![1]!.day.toString().padLeft(2, '0')}/${widget.dates![1]!.month.toString().padLeft(2, '0')}",
                          iconPath: r"assets/icon/calendar.svg",
                          onTap: widget.openDateSelector,
                        )
                      : SFSearchFilter(
                          labelText: widget.days!.isEmpty
                              ? "Dia"
                              : widget.days!
                                  .map((e) => weekdayShort[e])
                                  .join("/"),
                          iconPath: r"assets/icon/calendar.svg",
                          onTap: widget.openDateSelector,
                        )),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: SFSearchFilter(
                  labelText: widget.time == null
                      ? "Horário"
                      : "${widget.time!.start.hour.toString().padLeft(2, '0')}:${widget.time!.start.minute.toString().padLeft(2, '0')} - ${widget.time!.end.hour.toString().padLeft(2, '0')}:${widget.time!.end.minute.toString().padLeft(2, '0')}",
                  iconPath: r"assets/icon/clock.svg",
                  onTap: widget.openTimeSelector,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SFButton(
              buttonLabel: "Buscar horários",
              textPadding: const EdgeInsets.symmetric(vertical: 5),
              isPrimary: false,
              color: widget.primaryColor,
              iconPath: r"assets/icon/search.svg",
              onTap: widget.onTapSearch,
            ),
          ),
        ],
      ),
    );
  }
}
