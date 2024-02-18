import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class SFToggle extends StatefulWidget {
  List<String> labels;
  int selectedIndex = 0;
  Function(int) onChanged;

  SFToggle(this.labels, this.selectedIndex, this.onChanged, {super.key});
  @override
  State<SFToggle> createState() => _SFToggleState();
}

class _SFToggleState extends State<SFToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: divider,
          width: 1,
        ),
        color: secondaryPaper,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int labelIndex = 0;
              labelIndex < widget.labels.length;
              labelIndex++)
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.selectedIndex = labelIndex;
                    widget.onChanged(labelIndex);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  decoration: BoxDecoration(
                    borderRadius: labelIndex == 0
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(defaultBorderRadius),
                            topLeft: Radius.circular(defaultBorderRadius),
                          )
                        : labelIndex == widget.labels.length - 1
                            ? const BorderRadius.only(
                                bottomRight:
                                    Radius.circular(defaultBorderRadius),
                                topRight: Radius.circular(defaultBorderRadius),
                              )
                            : BorderRadius.circular(0),
                    border: Border.all(
                      color: divider,
                      width: 1,
                    ),
                    color: labelIndex == widget.selectedIndex
                        ? secondaryBack
                        : secondaryPaper,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.labels[labelIndex],
                    style: const TextStyle(color: textDarkGrey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
