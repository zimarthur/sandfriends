import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Utils/Constants.dart';

class SportSelectorModal extends StatefulWidget {
  final List<Sport> sports;
  final Sport? selectedSport;
  final Function(Sport) onSelectedSport;
  const SportSelectorModal({
    Key? key,
    required this.sports,
    required this.selectedSport,
    required this.onSelectedSport,
  }) : super(key: key);

  @override
  State<SportSelectorModal> createState() => _SportSelectorModalState();
}

class _SportSelectorModalState extends State<SportSelectorModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9 > 350 ? 350 : width * 0.9,
      height: height * 0.5 > 350 ? 350 : height * 0.5,
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      child: Column(
        children: [
          Text(
            "Selecione seu esporte de preferência",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var sport in widget.sports)
                  InkWell(
                    onTap: () => widget.onSelectedSport(
                      sport,
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: defaultPadding / 2),
                      padding: EdgeInsets.symmetric(
                          vertical: defaultPadding / 2,
                          horizontal: defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryBack,
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                        border: Border.all(
                          color: sport == widget.selectedSport
                              ? primaryBlue
                              : textLightGrey,
                          width: sport == widget.selectedSport ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            sport.iconLocation,
                            height: 20,
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Text(
                            sport.description,
                            style: TextStyle(
                                color: sport == widget.selectedSport
                                    ? textBlue
                                    : textDarkGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
