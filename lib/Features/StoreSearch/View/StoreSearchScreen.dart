import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/StoreSearch/View/StoreSearchWidget.dart';
import 'package:sandfriends/Features/StoreSearch/ViewModel/StoreSearchViewModel.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';

class StoreSearchScreen extends StatefulWidget {
  final int sportId;
  const StoreSearchScreen({
    Key? key,
    required this.sportId,
  }) : super(key: key);

  @override
  State<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  final viewModel = StoreSearchViewModel();

  @override
  void initState() {
    viewModel.initMatchSearchViewModel(context, widget.sportId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreSearchViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<StoreSearchViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: viewModel.titleText,
            rightWidget: InkWell(
              onTap: () => viewModel.goToSearchFilter(context),
              child: SvgPicture.asset(
                r"assets/icon/filter_off.svg",
                height: 25,
              ),
            ),
            appBarType: AppBarType.Primary,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.widgetForm,
            onTapBackground: () => viewModel.closeModal(),
            canTapBackground: viewModel.canTapBackground,
            onTapReturn: () => viewModel.onTapReturn(context),
            child: StoreSearchWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
