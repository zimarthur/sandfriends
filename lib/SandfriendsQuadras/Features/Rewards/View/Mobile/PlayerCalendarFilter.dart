import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends_web/SharedComponents/Model/EnumPeriodVisualization.dart';
import '../../../../SharedComponents/View/SFTextfield.dart';
import '../../../../Utils/Constants.dart';

double defaultHeigth = 50;

class PlayerCalendarFilter extends StatefulWidget {
  TextEditingController playerController;
  Function(EnumPeriodVisualization) onSelectedPeriod;
  EnumPeriodVisualization selectedPeriod;
  double? height;
  PlayerCalendarFilter(
      {required this.playerController,
      required this.onSelectedPeriod,
      required this.selectedPeriod,
      this.height,
      super.key});

  @override
  State<PlayerCalendarFilter> createState() => _PlayerCalendarFilterState();
}

class _PlayerCalendarFilterState extends State<PlayerCalendarFilter> {
  List<EnumPeriodVisualization> periods = periodVisualizationEnums;
  @override
  Widget build(BuildContext context) {
    double height = widget.height ?? defaultHeigth;
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: SFTextField(
              labelText: "Pesquisar jogador",
              pourpose: TextFieldPourpose.Standard,
              controller: widget.playerController,
              validator: (value) {},
            ),
          ),
          SizedBox(
            width: defaultPadding,
          ),
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            tooltip: "",
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              for (var drawerItem in periods)
                PopupMenuItem(
                  value: drawerItem,
                  onTap: () => widget.onSelectedPeriod(drawerItem),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          drawerItem.value,
                          style: TextStyle(
                            color: textDarkGrey,
                          ),
                        ),
                      ),
                      if (drawerItem == widget.selectedPeriod)
                        SvgPicture.asset(
                          r"assets/icon/check_circle.svg",
                          color: primaryBlue,
                        )
                    ],
                  ),
                ),
            ],
            onSelected: (value) {},
            child: Container(
              height: height,
              width: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
                border: Border.all(
                  width: 2,
                  color: divider,
                ),
                color: secondaryPaper,
              ),
              child: Center(
                child: SvgPicture.asset(
                  r"assets/icon/calendar.svg",
                  color: textDarkGrey,
                  height: height * 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
