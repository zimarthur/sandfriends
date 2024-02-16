import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Components/SFDropDown.dart';
import '../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/UserDetailsViewModel.dart';

class UserDetailsSportSelector extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsSportSelector({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsSportSelector> createState() =>
      _UserDetailsSportSelectorState();
}

class _UserDetailsSportSelectorState extends State<UserDetailsSportSelector> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Esporte",
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
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
                items: Provider.of<CategoriesProvider>(context, listen: false)
                    .sports
                    .map((e) => e.description)
                    .toList(),
                validator: (value) {
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: defaultPadding / 4,
            ),
            InkWell(
              onTap: () => widget.viewModel.setPreferenceSport(),
              child: widget.viewModel.displayedSport ==
                      widget.viewModel.userEdited.preferenceSport
                  ? SvgPicture.asset(
                      r"assets/icon/favorite_selected.svg",
                      width: width * 0.06,
                    )
                  : SvgPicture.asset(
                      r"assets/icon/favorite_unselected.svg",
                      width: width * 0.06,
                    ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 8,
        ),
        const Text(
          "Alterne entre os esportes para informar seu nível em cada um deles.",
          style: TextStyle(color: textDarkGrey),
          textScaleFactor: 0.8,
        ),
      ],
    );
  }
}
