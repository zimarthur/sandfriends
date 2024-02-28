import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_range/time_range.dart';

import '../../../../Common/Model/City.dart';
import '../../../../Common/Utils/Constants.dart';

class SearchFilter extends StatefulWidget {
  VoidCallback onTapLocation;
  VoidCallback onTapDate;
  VoidCallback onTapTime;
  City? city;
  List<DateTime?> dates;
  TimeRangeResult? time;
  VoidCallback onSearch;
  Axis direction;
  SearchFilter({
    required this.onTapLocation,
    required this.onTapDate,
    required this.onTapTime,
    required this.city,
    required this.dates,
    required this.time,
    required this.onSearch,
    required this.direction,
    super.key,
  });

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  bool isSearchHovered = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isVertical = widget.direction == Axis.vertical;
    return Container(
      height: isVertical ? 300 : 80,
      width: isVertical ? 250 : width * 0.6,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(
            defaultBorderRadius,
          ),
          bottomLeft: Radius.circular(
            isVertical ? 0 : defaultBorderRadius,
          ),
          topRight: Radius.circular(
            isVertical ? defaultBorderRadius : 0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: divider,
            blurRadius: 5,
            offset: Offset(
              2.0,
              5.0,
            ),
          )
        ],
      ),
      child: Flex(
        direction: isVertical ? Axis.horizontal : Axis.vertical,
        children: [
          Container(
            height: isVertical ? null : 5,
            width: isVertical ? 10 : null,
            color: primaryLightBlue,
          ),
          Expanded(
            child: Flex(
              //mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: widget.direction,
              children: [
                Expanded(
                  flex: isVertical ? 1 : 2,
                  child: SearchFilterItem(
                    title: "Onde",
                    hint: widget.city != null
                        ? widget.city!.cityState
                        : "Buscar cidades disponíveis",
                    onTap: () => widget.onTapLocation(),
                    isVertical: isVertical,
                  ),
                ),
                if (!isVertical)
                  Center(
                    child: Container(
                      width: 1,
                      height: 50,
                      color: divider,
                    ),
                  ),
                Expanded(
                  flex: 1,
                  child: SearchFilterItem(
                    title: "Datas",
                    hint: widget.dates.isEmpty
                        ? "Selecione os dias"
                        : widget.dates.length == 1
                            ? "${widget.dates[0]!.day.toString().padLeft(2, '0')}/${widget.dates[0]!.month.toString().padLeft(2, '0')}"
                            : "${widget.dates[0]!.day.toString().padLeft(2, '0')}/${widget.dates[0]!.month.toString().padLeft(2, '0')} - ${widget.dates[1]!.day.toString().padLeft(2, '0')}/${widget.dates[1]!.month.toString().padLeft(2, '0')}",
                    onTap: () => widget.onTapDate(),
                    isVertical: isVertical,
                  ),
                ),
                if (!isVertical)
                  Center(
                    child: Container(
                      width: 1,
                      height: 50,
                      color: divider,
                    ),
                  ),
                Expanded(
                  flex: 1,
                  child: SearchFilterItem(
                    title: "Horários",
                    hint: widget.time == null
                        ? "Informe o período"
                        : "${widget.time!.start.hour.toString().padLeft(2, '0')}:${widget.time!.start.minute.toString().padLeft(2, '0')} - ${widget.time!.end.hour.toString().padLeft(2, '0')}:${widget.time!.end.minute.toString().padLeft(2, '0')}",
                    onTap: () => widget.onTapTime(),
                    isVertical: isVertical,
                  ),
                ),
                InkWell(
                  onTap: () => widget.onSearch(),
                  onHover: (hovered) {
                    setState(() {
                      isSearchHovered = hovered;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                        vertical: isVertical ? defaultPadding : 0),
                    decoration: BoxDecoration(
                      color: isSearchHovered ? primaryDarkBlue : primaryBlue,
                      borderRadius: isVertical
                          ? BorderRadius.circular(
                              defaultPadding,
                            )
                          : null,
                      shape: isVertical ? BoxShape.rectangle : BoxShape.circle,
                    ),
                    height: 50,
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          r"assets/icon/search.svg",
                          color: textWhite,
                          height: 25,
                        ),
                        if (isVertical)
                          Padding(
                            padding: EdgeInsets.only(
                              left: defaultPadding / 2,
                            ),
                            child: Text(
                              "Buscar",
                              style: TextStyle(
                                color: textWhite,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchFilterItem extends StatefulWidget {
  String title;
  String hint;
  VoidCallback onTap;
  bool isVertical;
  SearchFilterItem({
    required this.title,
    required this.hint,
    required this.onTap,
    required this.isVertical,
    super.key,
  });

  @override
  State<SearchFilterItem> createState() => _SearchFilterItemState();
}

class _SearchFilterItemState extends State<SearchFilterItem> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      onHover: (hovered) {
        setState(() {
          isHovered = hovered;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(
              defaultBorderRadius,
            ),
            bottomLeft: Radius.circular(
              widget.isVertical ? 0 : defaultBorderRadius,
            ),
            topRight: Radius.circular(
              widget.isVertical ? defaultBorderRadius : 0,
            ),
          ),
          color: isHovered ? divider : secondaryPaper,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.hint,
              style: TextStyle(color: textDarkGrey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
