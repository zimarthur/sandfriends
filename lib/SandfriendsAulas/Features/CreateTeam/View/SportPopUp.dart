import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';

import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Utils/Constants.dart';

class SportPopUp extends StatefulWidget {
  Sport selectedSport;
  Function(Sport) onSelectedSport;
  SportPopUp({
    required this.selectedSport,
    required this.onSelectedSport,
    super.key,
  });

  @override
  State<SportPopUp> createState() => _SportFilterState();
}

class _SportFilterState extends State<SportPopUp> {
  late List<Sport> sports;
  @override
  void initState() {
    sports = Provider.of<CategoriesProvider>(context, listen: false).sports;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      surfaceTintColor: secondaryPaper,
      onSelected: (sport) => widget.onSelectedSport(sport),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        for (var sport in sports)
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
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icon/sport_icon_${widget.selectedSport.idSport}.svg",
              height: 25,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              widget.selectedSport.description,
              style: TextStyle(color: textDarkGrey),
            )
          ],
        ),
      ),
    );
  }
}
