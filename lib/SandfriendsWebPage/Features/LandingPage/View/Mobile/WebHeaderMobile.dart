import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../../Common/Providers/Categories/CategoriesProvider.dart';

class WebHeaderMobile extends StatelessWidget {
  const WebHeaderMobile({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: defaultPadding / 4,
      ),
      color: primaryBlue,
      child: Row(
        children: [
          SvgPicture.asset(
            r"assets/icon/logo_negative.svg",
            width: width * 0.4 > 150 ? 150 : width * 0.4,
          ),
          Expanded(
            child: Container(),
          ),
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            tooltip: "",
            surfaceTintColor: secondaryPaper,
            onSelected: (sport) {
              Provider.of<CategoriesProvider>(context, listen: false)
                  .setSessionSport(sport: sport);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              for (var sport
                  in Provider.of<CategoriesProvider>(context, listen: false)
                      .sports)
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
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: SvgPicture.asset(
                "assets/icon/sport_icon_${Provider.of<CategoriesProvider>(context).sessionSport!.idSport}.svg",
                height: 25,
              ),
            ),
          ),
          SizedBox(
            width: defaultPadding / 2,
          ),
          InkWell(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SvgPicture.asset(
                r"assets/icon/menu_burger.svg",
                color: textWhite,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
