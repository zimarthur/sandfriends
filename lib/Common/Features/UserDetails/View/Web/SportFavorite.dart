import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../Model/Sport.dart';

class SportFavorite extends StatefulWidget {
  Sport favoriteSport;
  Sport currentSport;
  Function(Sport) onChange;
  Function(Sport) onFavorite;
  SportFavorite({
    required this.favoriteSport,
    required this.currentSport,
    required this.onChange,
    required this.onFavorite,
    super.key,
  });

  @override
  State<SportFavorite> createState() => _SportFavoriteState();
}

class _SportFavoriteState extends State<SportFavorite> {
  late List<Sport> sports;

  @override
  void initState() {
    sports = Provider.of<CategoriesProvider>(context, listen: false).sports;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            int currentIndex = sports.indexOf(widget.currentSport);
            widget.onChange(
              currentIndex == 0
                  ? sports.last
                  : widget.currentSport = sports[currentIndex - 1],
            );
          },
          child: SvgPicture.asset(
            r"assets/icon/chevron_left.svg",
            color: primaryBlue,
            height: 25,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: defaultPadding / 4,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding / 2,
              vertical: defaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: secondaryPaper,
              borderRadius: BorderRadius.circular(
                defaultBorderRadius,
              ),
              border: Border.all(color: primaryBlue, width: 2),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  widget.currentSport.iconLocation,
                  height: 25,
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                Expanded(
                  child: Text(
                    widget.currentSport.description,
                    style: TextStyle(
                      color: primaryBlue,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => widget.onFavorite(widget.currentSport),
                  child: SvgPicture.asset(
                    widget.currentSport.idSport == widget.favoriteSport.idSport
                        ? "assets/icon/favorite_selected.svg"
                        : "assets/icon/favorite_unselected.svg",
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            int currentIndex = sports.indexOf(widget.currentSport);
            widget.onChange(
              currentIndex == (sports.length - 1)
                  ? sports.first
                  : sports[currentIndex + 1],
            );
          },
          child: SvgPicture.asset(
            r"assets/icon/chevron_right.svg",
            color: primaryBlue,
            height: 25,
          ),
        ),
      ],
    );
  }
}
