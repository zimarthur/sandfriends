import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableHour.dart';

import '../../../../Utils/Constants.dart';
import '../../../Court/Model/HourPrice.dart';

class AvailableHourCard extends StatefulWidget {
  HourPrice hourPrice;
  Function(HourPrice) onTap;
  bool isSelected;

  AvailableHourCard({
    required this.hourPrice,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<AvailableHourCard> createState() => _AvailableHourCardState();
}

class _AvailableHourCardState extends State<AvailableHourCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(
        widget.hourPrice,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: widget.isSelected ? primaryBlue : secondaryPaper,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryBlue,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      r"assets\icon\clock.svg",
                      color: widget.isSelected ? textWhite : primaryBlue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.hourPrice.hour.hourString,
                          style: TextStyle(
                            color: widget.isSelected ? textWhite : primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      r"assets\icon\payment.svg",
                      color: widget.isSelected ? textWhite : primaryBlue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${widget.hourPrice.price}/h",
                          style: TextStyle(
                            color: widget.isSelected ? textWhite : textBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
