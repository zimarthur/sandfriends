import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Common/Utils/Constants.dart';
import '../../Model/HourPrice/HourPriceUser.dart';

class AvailableHourCard extends StatefulWidget {
  final HourPriceUser hourPrice;
  final Function(HourPriceUser) onTap;
  final bool isSelected;
  final bool isRecurrent;

  const AvailableHourCard({
    Key? key,
    required this.hourPrice,
    required this.onTap,
    required this.isSelected,
    required this.isRecurrent,
  }) : super(key: key);

  @override
  State<AvailableHourCard> createState() => _AvailableHourCardState();
}

class _AvailableHourCardState extends State<AvailableHourCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    bool isSelectedOrHovered = widget.isSelected || isHovered;
    return MouseRegion(
      onEnter: (pointer) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (pointer) {
        setState(() {
          isHovered = false;
        });
      },
      child: InkWell(
        onTap: () => widget.onTap(
          widget.hourPrice,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
            width: 80,
            decoration: BoxDecoration(
              color: isSelectedOrHovered
                  ? widget.isRecurrent
                      ? primaryLightBlue
                      : primaryBlue
                  : secondaryPaper,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isRecurrent ? primaryLightBlue : primaryBlue,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        r"assets/icon/clock.svg",
                        color: isSelectedOrHovered
                            ? textWhite
                            : widget.isRecurrent
                                ? primaryLightBlue
                                : primaryBlue,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.hourPrice.hour.hourString,
                            style: TextStyle(
                              color: isSelectedOrHovered
                                  ? textWhite
                                  : widget.isRecurrent
                                      ? primaryLightBlue
                                      : primaryBlue,
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
                        r"assets/icon/price.svg",
                        color: isSelectedOrHovered
                            ? textWhite
                            : widget.isRecurrent
                                ? primaryLightBlue
                                : primaryBlue,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${widget.hourPrice.price.toInt()}/h",
                            style: TextStyle(
                              color: isSelectedOrHovered
                                  ? textWhite
                                  : widget.isRecurrent
                                      ? primaryLightBlue
                                      : primaryBlue,
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
      ),
    );
  }
}
