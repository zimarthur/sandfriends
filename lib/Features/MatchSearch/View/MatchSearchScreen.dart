import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/MatchSearchViewModel.dart';
import 'MatchSearchWidget.dart';

class MatchSearchScreen extends StatefulWidget {
  final int sportId;
  const MatchSearchScreen({
    Key? key,
    required this.sportId,
  }) : super(key: key);

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreenState();
}

class _MatchSearchScreenState extends State<MatchSearchScreen> {
  final viewModel = MatchSearchViewModel();

  @override
  void initState() {
    viewModel.initMatchSearchViewModel(context, widget.sportId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatchSearchViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<MatchSearchViewModel>(
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
            child: MatchSearchWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
