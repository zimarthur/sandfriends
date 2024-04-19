import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/Model/CustomFilter.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/View/FilterBasicWidget.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/View/MatchSearchFilterWidget.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearchFilter/ViewModel/MatchSearchFilterViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/Model/City.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../MatchSearch/ViewModel/MatchSearchViewModel.dart';

class MatchSearchFilterScreen extends StatefulWidget {
  CustomFilter defaultCustomFilter;
  CustomFilter currentCustomFilter;
  City? selectedCityId;
  bool? hideOrderBy;
  bool? isRecurrent;
  MatchSearchFilterScreen({
    required this.defaultCustomFilter,
    required this.currentCustomFilter,
    required this.selectedCityId,
    required this.hideOrderBy,
    required this.isRecurrent,
    super.key,
  });

  @override
  State<MatchSearchFilterScreen> createState() =>
      _MatchSearchFilterScreenState();
}

class _MatchSearchFilterScreenState extends State<MatchSearchFilterScreen> {
  final viewModel = MatchSearchFilterViewModel();

  @override
  void initState() {
    viewModel.initViewModel(
      widget.defaultCustomFilter,
      widget.currentCustomFilter,
      widget.selectedCityId,
      widget.hideOrderBy,
      widget.isRecurrent,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatchSearchFilterViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<MatchSearchFilterViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Filtros",
            customOnTapReturn: () => viewModel.onReturn(context),
            // rightWidget: viewModel.customFilterHasChanged
            //     ? InkWell(
            //         onTap: () => viewModel.clearFilter(),
            //         child: Text(
            //           "Limpar",
            //           style: TextStyle(
            //             color: textWhite,
            //           ),
            //         ),
            //       )
            //     : Container(),
            appBarType: viewModel.isRecurrent
                ? AppBarType.PrimaryLightBlue
                : AppBarType.Primary,
            child: FilterBasicWidget(), // MatchSearchFilterWidget(),
          );
        },
      ),
    );
  }
}
