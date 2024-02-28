import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../Common/Utils/Constants.dart';

class WebHeader extends StatefulWidget {
  const WebHeader({super.key});

  @override
  State<WebHeader> createState() => WebHeaderState();
}

class WebHeaderState extends State<WebHeader> {
  bool isSportHovered = false;
  bool isProfileHovered = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 80,
      color: primaryBlue,
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Row(
        children: [
          InkWell(
              onTap: () => Navigator.pushNamed(context,
                  "/quadras/open-beach"), //Navigator.pushReplacementNamed(context, "/"),
              child: Image.asset(
                  r"assets/sandfriends_logo_alternative_negative.png")),
          Expanded(
            child: Container(),
          ),
          if (Provider.of<CategoriesProvider>(context).sessionSport != null)
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
              child: MouseRegion(
                onEnter: (pointer) {
                  setState(() {
                    isSportHovered = true;
                  });
                },
                onExit: (pointer) {
                  setState(() {
                    isSportHovered = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    border: Border.all(
                      color: divider,
                      width: 2,
                    ),
                    color: secondaryPaper,
                    boxShadow: [
                      if (isSportHovered)
                        BoxShadow(
                          color: divider,
                          blurRadius: 5,
                          offset: Offset(
                            0,
                            3.0,
                          ),
                        )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icon/sport_icon_${Provider.of<CategoriesProvider>(context).sessionSport!.idSport}.svg",
                        height: 25,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        Provider.of<CategoriesProvider>(context)
                            .sessionSport!
                            .description,
                        style: TextStyle(
                          color: textDarkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(
            width: defaultPadding,
          ),
          MouseRegion(
            onEnter: (pointer) {
              setState(() {
                isProfileHovered = true;
              });
            },
            onExit: (pointer) {
              setState(() {
                isProfileHovered = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                border: Border.all(
                  color: divider,
                  width: 2,
                ),
                color: secondaryPaper,
                boxShadow: [
                  if (isProfileHovered)
                    BoxShadow(
                      color: divider,
                      blurRadius: 5,
                      offset: Offset(
                        0,
                        3.0,
                      ),
                    )
                ],
              ),
              padding: EdgeInsets.all(defaultPadding / 2),
              child: Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/user.svg",
                    height: 25,
                    color: textDarkGrey,
                  ),
                  SvgPicture.asset(
                    r"assets/icon/three_dots.svg",
                    height: 25,
                    color: textDarkGrey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
