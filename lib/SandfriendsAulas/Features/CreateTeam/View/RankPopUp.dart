import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Rank.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';

import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Utils/Constants.dart';

class RankPopUp extends StatefulWidget {
  Rank? selectedRank;
  Sport currentSport;
  Function(Rank) onSelectedRank;
  RankPopUp({
    required this.selectedRank,
    required this.currentSport,
    required this.onSelectedRank,
    super.key,
  });

  @override
  State<RankPopUp> createState() => _SportFilterState();
}

class _SportFilterState extends State<RankPopUp> {
  late List<Rank> ranks;
  @override
  void initState() {
    ranks = Provider.of<CategoriesProvider>(context, listen: false)
        .ranks
        .where((rank) => rank.sport == widget.currentSport)
        .toList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RankPopUp oldWidget) {
    if (oldWidget.currentSport != widget.currentSport) {
      ranks = Provider.of<CategoriesProvider>(context, listen: false)
          .ranks
          .where((rank) => rank.sport == widget.currentSport)
          .toList();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      surfaceTintColor: secondaryPaper,
      onSelected: (rank) => widget.onSelectedRank(rank),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        for (var rank in ranks)
          PopupMenuItem(
            value: rank,
            child: Center(
              child: Text(
                rank.name,
                style: TextStyle(
                  color: rank.colorObj,
                ),
              ),
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
          child: Center(
            child: widget.selectedRank == null
                ? Text(
                    "-",
                    style: TextStyle(
                      color: textDarkGrey,
                    ),
                  )
                : Text(
                    widget.selectedRank!.name,
                    style: TextStyle(
                      color: widget.selectedRank!.colorObj,
                    ),
                  ),
          )),
    );
  }
}
