import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../Components/SFDropDown.dart';
import '../../../Providers/Categories/CategoriesProvider.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/UserDetailsViewModel.dart';
import 'Web/SportFavorite.dart';

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
        SportFavorite(
          currentSport: widget.viewModel.displayedSport,
          onChange: (sport) =>
              widget.viewModel.changedDisplayedSport(context, sport),
          favoriteSport: widget.viewModel.userEdited.preferenceSport!,
          onFavorite: (sport) => widget.viewModel.setPreferenceSport(),
        ),
        const SizedBox(
          height: defaultPadding / 8,
        ),
        const Text(
          "Alterne entre os esportes para informar seu nível em cada um deles.",
          style: TextStyle(
            color: textDarkGrey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
