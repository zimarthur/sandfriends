import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Utils/Constants.dart';

class TeamDetailsAbout extends StatelessWidget {
  const TeamDetailsAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Descrição",
          style: TextStyle(
            color: primaryLightBlue,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: defaultPadding / 4,
        ),
        Text(
          "s simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
          style: TextStyle(
            color: textDarkGrey,
            fontSize: 12,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Text(
          "Onde",
          style: TextStyle(
            color: primaryLightBlue,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: defaultPadding / 4,
        ),
        SizedBox(
          height: 70,
          child: Row(
            children: [
              SFAvatarStore(
                height: 70,
                storeName: "Beach Brasil",
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Beach Brasil",
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding / 4,
                    ),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          r"assets/icon/location_ping.svg",
                          color: textDarkGrey,
                          height: 15,
                        ),
                        SizedBox(
                          width: defaultPadding / 4,
                        ),
                        Expanded(
                          child: Text(
                            "Rua 14 de julho, 291 - Boa Vista. Porto Alegre - RS",
                            style: TextStyle(
                              color: textDarkGrey,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Text(
          "Quando",
          style: TextStyle(
            color: primaryLightBlue,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: defaultPadding / 4,
        ),
        Text(
          "Segunda-feira",
          style: TextStyle(
            color: textDarkGrey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: defaultPadding / 2),
          child: Row(
            children: [
              SvgPicture.asset(
                r"assets/icon/clock.svg",
                color: textDarkGrey,
                height: 15,
              ),
              SizedBox(
                width: defaultPadding / 4,
              ),
              Text(
                "09:00 - 10:00",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: defaultPadding / 2),
          child: Row(
            children: [
              SvgPicture.asset(
                r"assets/icon/clock.svg",
                color: textDarkGrey,
                height: 15,
              ),
              SizedBox(
                width: defaultPadding / 4,
              ),
              Text(
                "17:00 - 18:00",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Text(
          "Turma (6)",
          style: TextStyle(
            color: primaryLightBlue,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
