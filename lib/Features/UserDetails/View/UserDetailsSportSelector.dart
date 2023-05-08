import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../../oldApp/widgets/SF_Dropdown.dart';

class UserDetailsSportSelector extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsSportSelector({
    required this.viewModel,
  });

  @override
  State<UserDetailsSportSelector> createState() =>
      _UserDetailsSportSelectorState();
}

class _UserDetailsSportSelectorState extends State<UserDetailsSportSelector> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Esporte",
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: defaultPadding / 4,
          ),
          Row(
            children: [
              Expanded(
                child: SFDropdown(
                  onChanged: (String? newValue) =>
                      widget.viewModel.changedDisplayedSport(context, newValue),
                  controller: widget.viewModel.displayedSport.description,
                  labelText: "",
                  items: Provider.of<DataProvider>(context, listen: false)
                      .sports
                      .map((e) => e.description)
                      .toList(),
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: defaultPadding / 4,
              ),
              InkWell(
                onTap: () => widget.viewModel.setPreferenceSport(),
                child: widget.viewModel.displayedSport ==
                        widget.viewModel.userEdited.preferenceSport
                    ? SvgPicture.asset(
                        r"assets\icon\favorite_selected.svg",
                        width: width * 0.06,
                      )
                    : SvgPicture.asset(
                        r"assets\icon\favorite_unselected.svg",
                        width: width * 0.06,
                      ),
              ),
            ],
          ),
          SizedBox(
            height: defaultPadding / 8,
          ),
          Text(
            "Alterne entre os esportes para informar seu nível em cada um deles.",
            style: TextStyle(color: textDarkGrey),
            textScaleFactor: 0.8,
          ),
        ],
      );
    });
  }
}