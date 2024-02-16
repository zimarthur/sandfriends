import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Utils/Constants.dart';

class SportFilter extends StatefulWidget {
  Sport selectedSport;
  List<Sport> availableSports;
  Function(Sport) onSelectedSport;
  SportFilter(
      {required this.selectedSport,
      required this.availableSports,
      required this.onSelectedSport,
      super.key});

  @override
  State<SportFilter> createState() => _SportFilterState();
}

class _SportFilterState extends State<SportFilter> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      surfaceTintColor: secondaryPaper,
      onSelected: (sport) => widget.onSelectedSport(sport),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        for (var sport in widget.availableSports)
          PopupMenuItem(
            value: sport,
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icon/sport_icon_${sport.idSport}.svg",
                  height: 20,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  sport.description,
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: secondaryPaper,
          border: Border.all(color: divider),
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(2, 3),
              color: divider,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding / 4,
          horizontal: defaultPadding / 2,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icon/sport_icon_${widget.selectedSport.idSport}.svg",
              height: 25,
            ),
            SizedBox(
              width: defaultPadding / 4,
            ),
            SvgPicture.asset(
              r"assets/icon/chevron_down.svg",
              color: textDarkGrey,
            ),
          ],
        ),
      ),
    );
  }
}
