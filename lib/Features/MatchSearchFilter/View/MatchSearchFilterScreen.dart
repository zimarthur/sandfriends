import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/MatchSearchFilter/Model/CustomFilter.dart';
import 'package:sandfriends/Features/MatchSearchFilter/View/FilterBasicWidget.dart';
import 'package:sandfriends/Features/MatchSearchFilter/View/MatchSearchFilterWidget.dart';
import 'package:sandfriends/Features/MatchSearchFilter/ViewModel/MatchSearchFilterViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../MatchSearch/ViewModel/MatchSearchViewModel.dart';

class MatchSearchFilterScreen extends StatefulWidget {
  CustomFilter defaultCustomFilter;
  CustomFilter currentCustomFilter;
  City? selectedCityId;
  bool? hideOrderBy;
  MatchSearchFilterScreen(
      {required this.defaultCustomFilter,
      required this.currentCustomFilter,
      required this.selectedCityId,
      required this.hideOrderBy,
      super.key});

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
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatchSearchFilterViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<MatchSearchFilterViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: "Filtros",
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
            appBarType: AppBarType.Primary,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.widgetForm,
            onTapBackground: () => viewModel.closeModal(),
            canTapBackground: viewModel.canTapBackground,
            onTapReturn: () => viewModel.onTapReturn(context),
            child: FilterBasicWidget(), // MatchSearchFilterWidget(),
          );
        },
      ),
    );
  }
}
