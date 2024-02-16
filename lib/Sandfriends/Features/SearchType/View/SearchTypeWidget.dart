import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../Providers/UserProvider/UserProvider.dart';

class SearchTypeWidget extends StatefulWidget {
  bool showReturnArrow;
  bool isRecurrent;
  SearchTypeWidget({
    required this.showReturnArrow,
    required this.isRecurrent,
    super.key,
  });

  @override
  State<SearchTypeWidget> createState() => _SearchTypeWidgetState();
}

class _SearchTypeWidgetState extends State<SearchTypeWidget> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor =
        widget.isRecurrent ? primaryLightBlue : primaryDarkBlue;
    Color secondaryColor =
        widget.isRecurrent ? primaryDarkBlue : primaryLightBlue;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      color: primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showReturnArrow)
              Padding(
                padding: EdgeInsets.only(top: defaultPadding / 2),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: defaultPadding * 3,
                    width: defaultPadding * 3,
                    padding: EdgeInsets.all(defaultPadding / 2),
                    decoration: const BoxDecoration(
                        color: secondaryBack, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      r'assets/icon/arrow_left.svg',
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          widget.isRecurrent
                              ? '/recurrent_match_search'
                              : '/match_search',
                          arguments: {
                            'sportId': Provider.of<UserProvider>(context,
                                    listen: false)
                                .user!
                                .preferenceSport!
                                .idSport,
                          });
                    },
                    child: SearchTypeItem(
                      icon: r"assets/icon/search_by_default.svg",
                      title: "Buscar por horário",
                      description: widget.isRecurrent
                          ? "Informe o dia e hora que pode jogar e receba todas opções de horário mensalistas disponíveis!"
                          : "Informe o dia e hora que pode jogar e receba todas opções de horário e partidas abertas disponíveis!",
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/store_search', arguments: {
                        'sportId':
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .preferenceSport!
                                .idSport,
                        'isRecurrent': widget.isRecurrent,
                      });
                    },
                    child: SearchTypeItem(
                      icon: r"assets/icon/search_by_store.svg",
                      title: "Buscar por quadra",
                      description: widget.isRecurrent
                          ? "Já sabe onde quer jogar? Encontre sua quadra favorita com a busca por quadras e seja mensalista."
                          : "Já sabe onde quer jogar? Encontre sua quadra favorita com a busca por quadras e agende sua partida.",
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchTypeItem extends StatelessWidget {
  String icon;
  String title;
  String description;
  Color primaryColor;
  Color secondaryColor;
  SearchTypeItem(
      {required this.icon,
      required this.title,
      required this.description,
      required this.primaryColor,
      required this.secondaryColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
          border: Border.all(
            color: secondaryColor,
            width: 5,
          ),
          color: secondaryBack),
      child: Column(
        children: [
          SvgPicture.asset(icon),
          SizedBox(
            height: defaultPadding,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
              color: primaryColor,
            ),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            description,
            style: TextStyle(
              color: textDarkGrey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
