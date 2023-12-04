import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/Sport.dart';
import 'package:sandfriends/SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';

class SportSelectorWidget extends StatefulWidget {
  Sport selectedSport;
  Function(Sport) onSelectedSport;
  SportSelectorWidget(
      {required this.selectedSport, required this.onSelectedSport, super.key});

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
          ),
      ],
    );
  }
}

class SportItem extends StatelessWidget {
  Sport sport;
  bool isSelected;
  Function(Sport) onTapSport;
  SportItem({
    required this.sport,
    required this.isSelected,
    required this.onTapSport,
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
            color: isSelected ? primaryBlue.withAlpha(64) : secondaryPaper,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icon/sport_icon_${sport.idSport}.svg",
                color: isSelected ? primaryBlue : textDarkGrey,
                height: 30,
              ),
              if (isSelected)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: defaultPadding / 2),
                    child: Text(
                      sport.description,
                      style: TextStyle(
                        color: textBlue,
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
