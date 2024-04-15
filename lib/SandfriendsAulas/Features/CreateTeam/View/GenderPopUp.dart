import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Gender.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';

import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Utils/Constants.dart';

class GenderPopUp extends StatefulWidget {
  Gender selectedGender;
  Function(Gender) onSelectedGender;
  GenderPopUp({
    required this.selectedGender,
    required this.onSelectedGender,
    super.key,
  });

  @override
  State<GenderPopUp> createState() => _SportFilterState();
}

class _SportFilterState extends State<GenderPopUp> {
  late List<Gender> genders;
  @override
  void initState() {
    genders = Provider.of<CategoriesProvider>(context, listen: false).genders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      surfaceTintColor: secondaryPaper,
      onSelected: (gender) => widget.onSelectedGender(gender),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        for (var gender in genders)
          PopupMenuItem(
            value: gender,
            child: Center(
              child: Text(
                gender.name,
                style: TextStyle(
                  color: textDarkGrey,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.selectedGender.name,
              style: TextStyle(color: textDarkGrey),
            )
          ],
        ),
      ),
    );
  }
}
