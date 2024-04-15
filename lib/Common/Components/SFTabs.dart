import 'package:flutter/material.dart';

import '../Model/TabItem.dart';
import '../Utils/Constants.dart';

class SFTabs extends StatefulWidget {
  List<SFTabItem> tabs;
  SFTabItem selectedPosition;
  bool expanded;
  Color color;

  SFTabs({
    super.key,
    required this.tabs,
    required this.selectedPosition,
    this.expanded = false,
    this.color = primaryBlue,
  });

  @override
  State<SFTabs> createState() => _SFTabsState();
}

class _SFTabsState extends State<SFTabs> {
  double tabWidth = 150;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      if (widget.expanded) {
        tabWidth = layoutConstraints.maxWidth / widget.tabs.length;
      }
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
                              ? widget.color
                              : textDarkGrey,
                          fontWeight: FontWeight.bold,
                        ),
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
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
