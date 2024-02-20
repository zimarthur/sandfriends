import 'package:flutter/material.dart';

import '../Model/TabItem.dart';
import '../Utils/Constants.dart';

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
  double tabWidth = 150;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: widget.tabs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (() {
                    setState(() {
                      widget.tabs[index].onTap(widget.tabs[index]);
                    });
                  }),
                  child: Container(
                    alignment: Alignment.center,
                    width: tabWidth,
                    child: Text(
                      widget.tabs[index].name,
                      style: TextStyle(
                          color: index ==
                                  widget.tabs.indexOf(widget.selectedPosition)
                              ? textBlue
                              : textDarkGrey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
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
