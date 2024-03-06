import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';

import '../../Common/Utils/Constants.dart';

class SportSelectorWidget extends StatefulWidget {
  Sport selectedSport;
  Function(Sport) onSelectedSport;
  Color primaryColor;
  SportSelectorWidget({
    required this.selectedSport,
    required this.onSelectedSport,
    required this.primaryColor,
    super.key,
  });

  @override
  State<SportSelectorWidget> createState() => _SportSelectorWidgetState();
}

class _SportSelectorWidgetState extends State<SportSelectorWidget> {
  List<Sport> availableSports = [];

  @override
  void initState() {
    availableSports =
        Provider.of<CategoriesProvider>(context, listen: false).sports;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var sport in availableSports)
          SportItem(
            sport: sport,
            isSelected: sport.idSport == widget.selectedSport.idSport,
            onTapSport: (newSport) => widget.onSelectedSport(newSport),
            primaryColor: widget.primaryColor,
          ),
      ],
    );
  }
}

class SportItem extends StatelessWidget {
  Sport sport;
  bool isSelected;
  Function(Sport) onTapSport;
  Color primaryColor;
  SportItem({
    required this.sport,
    required this.isSelected,
    required this.onTapSport,
    required this.primaryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isSelected ? 3 : 1,
      child: InkWell(
        onTap: () => onTapSport(sport),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultPadding / 2,
          ),
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            border: isSelected
                ? null
                : Border.all(
                    color: textDarkGrey,
                  ),
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
            color: isSelected ? primaryColor.withAlpha(64) : secondaryPaper,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icon/sport_icon_${sport.idSport}.svg",
                height: 30,
              ),
              if (isSelected)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: defaultPadding / 2),
                    child: Text(
                      sport.description,
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
