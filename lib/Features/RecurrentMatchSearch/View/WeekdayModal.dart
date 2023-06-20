import 'package:flutter/material.dart';
import 'package:sandfriends/Utils/SFDateTime.dart';

import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';

class WeekdayModal extends StatefulWidget {
  List<int> selectedWeekdays;
  VoidCallback onSelected;
  WeekdayModal({
    required this.selectedWeekdays,
    required this.onSelected,
  });

  @override
  State<WeekdayModal> createState() => _WeekdayModalState();
}

class _WeekdayModalState extends State<WeekdayModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height * 0.6,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: weekDaysPortuguese.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (widget.selectedWeekdays.contains(index)) {
                        widget.selectedWeekdays.remove(index);
                      } else {
                        widget.selectedWeekdays.add(index);
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.05),
                    decoration: BoxDecoration(
                      color: secondaryBack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.selectedWeekdays.contains(index)
                            ? primaryLightBlue
                            : textLightGrey,
                        width: widget.selectedWeekdays.contains(index) ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      weekDaysPortuguese[index],
                      style: TextStyle(
                          color: widget.selectedWeekdays.contains(index)
                              ? primaryLightBlue
                              : textDarkGrey),
                    ),
                  ),
                );
              },
            ),
          ),
          SFButton(
            buttonLabel: "Concluído",
            color: primaryLightBlue,
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.02,
            ),
            onTap: widget.onSelected,
          )
        ],
      ),
    );
  }
}
