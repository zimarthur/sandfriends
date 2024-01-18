import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/Home/View/SeachTypeSelector/SearchTypeEnum.dart';
import 'package:sandfriends/Utils/Constants.dart';

class SearchTypeSelectorWidget extends StatefulWidget {
  Function(SearchType) onSelect;
  SearchTypeSelectorWidget({
    required this.onSelect,
    super.key,
  });

  @override
  State<SearchTypeSelectorWidget> createState() =>
      _SearchTypeSelectorWidgetState();
}

class _SearchTypeSelectorWidgetState extends State<SearchTypeSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      color: primaryDarkBlue,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => widget.onSelect(SearchType.Default),
              child: SearchTypeItem(
                icon: r"assets/icon/search_by_default.svg",
                title: "Buscar por horário",
                description:
                    "Informe o dia e hora que pode jogar e receba todas opções de horário e partidas abertas disponíveis!",
              ),
            ),
            InkWell(
              onTap: () => widget.onSelect(SearchType.ByStore),
              child: SearchTypeItem(
                icon: r"assets/icon/search_by_store.svg",
                title: "Buscar por quadra",
                description:
                    "Já sabe onde quer jogar? Encontre sua quadra favorita com a busca por quadras e agende sua partida.",
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
  SearchTypeItem(
      {required this.icon,
      required this.title,
      required this.description,
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
            color: primaryLightBlue,
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
              color: primaryDarkBlue,
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
