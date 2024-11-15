import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Components/SFDropDown.dart';
import '../../../../../Common/Model/Hour.dart';
import '../../../../../Common/Model/SandfriendsQuadras/StoreWorkingHours.dart';
import '../../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/SFDateTime.dart';
import '../../../Menu/ViewModel/StoreProvider.dart';

class HourSelector extends StatefulWidget {
  StoreWorkingDay storeWorkingDay;
  List<Hour> availableHours;

  HourSelector({
    super.key,
    required this.storeWorkingDay,
    required this.availableHours,
  });

  @override
  State<HourSelector> createState() => _HourSelectorState();
}

class _HourSelectorState extends State<HourSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.storeWorkingDay.isEnabled,
            onChanged: (value) {
              setState(() {
                widget.storeWorkingDay.isEnabled = value!;
                widget.storeWorkingDay.startingHour =
                    Provider.of<CategoriesProvider>(context, listen: false)
                        .hours
                        .reduce((a, b) => a.hour < b.hour ? a : b);
                widget.storeWorkingDay.endingHour =
                    Provider.of<CategoriesProvider>(context, listen: false)
                        .hours
                        .reduce((a, b) => a.hour > b.hour ? a : b);
              });
            }),
        const SizedBox(
          width: defaultPadding,
        ),
        Expanded(
          child: Text(
            weekdayFull[widget.storeWorkingDay.weekday],
            style: TextStyle(
                color: widget.storeWorkingDay.isEnabled
                    ? textBlack
                    : textLightGrey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.storeWorkingDay.isEnabled)
          Row(
            children: [
              SFDropdown(
                labelText: widget.storeWorkingDay.startingHour!.hourString,
                items: widget.availableHours
                    .where((hour) =>
                        hour.hour < widget.storeWorkingDay.endingHour!.hour)
                    .map((hour) => hour.hourString)
                    .toList(),
                validator: (a) {
                  return null;
                },
                onChanged: (newStartingHour) {
                  setState(() {
                    widget.storeWorkingDay.startingHour = widget.availableHours
                        .firstWhere(
                            (element) => element.hourString == newStartingHour);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "até",
                  style: TextStyle(
                      color: widget.storeWorkingDay.isEnabled
                          ? textBlack
                          : textLightGrey),
                ),
              ),
              SFDropdown(
                labelText: widget.storeWorkingDay.endingHour!.hourString,
                items: widget.availableHours
                    .where((hour) =>
                        hour.hour > widget.storeWorkingDay.startingHour!.hour)
                    .map((hour) => hour.hourString)
                    .toList(),
                validator: (newEndingHour) {
                  return null;
                },
                onChanged: (newEndingHour) {
                  setState(() {
                    widget.storeWorkingDay.endingHour = widget.availableHours
                        .firstWhere(
                            (element) => element.hourString == newEndingHour);
                  });
                },
              ),
            ],
          ),
      ],
    );
  }
}
