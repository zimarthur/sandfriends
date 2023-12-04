import 'package:flutter/material.dart';

import '../../Utils/Constants.dart';
import '../Model/TabItem.dart';

class SFTabs extends StatefulWidget {
  List<SFTabItem> tabs;
  SFTabItem selectedPosition;

  SFTabs({
    super.key,
    required this.tabs,
    required this.selectedPosition,
  });

  @override
  State<SFTabs> createState() => _SFTabsState();
}

class _SFTabsState extends State<SFTabs> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double tabWidth = width / widget.tabs.length;
    return SizedBox(
      width: width,
      height: 50,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                for (int i = 0; i < widget.tabs.length; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () => widget.tabs[i].onTap(widget.tabs[i]),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.tabs[i].name,
                          style: TextStyle(
                              color: i ==
                                      widget.tabs
                                          .indexOf(widget.selectedPosition)
                                  ? textBlue
                                  : textDarkGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                height: 2,
                width: double.infinity,
                color: divider,
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: tabWidth * widget.tabs.indexOf(widget.selectedPosition),
                child: Container(
                  height: 4,
                  width: tabWidth,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
