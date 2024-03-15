import 'package:flutter/material.dart';

import '../../../../Utils/Constants.dart';

class ReservationStepWidget extends StatefulWidget {
  String step;
  String description;
  bool isActive;
  Widget child;
  ReservationStepWidget({
    required this.step,
    required this.description,
    required this.isActive,
    required this.child,
    super.key,
  });

  @override
  State<ReservationStepWidget> createState() => _ReservationStepWidgetState();
}

class _ReservationStepWidgetState extends State<ReservationStepWidget> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.isActive ? primaryBlue : textDarkGrey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Text(
              widget.step,
              style: TextStyle(color: textWhite),
            ),
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2 * defaultPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.description,
                      style: TextStyle(color: color),
                    ),
                  ),
                ),
                if (widget.isActive) widget.child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
