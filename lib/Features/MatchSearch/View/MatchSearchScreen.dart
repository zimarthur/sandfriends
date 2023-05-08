import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/MatchSearch/View/MatchSearchWidget.dart';
import 'package:sandfriends/Features/MatchSearch/ViewModel/MatchSearchViewModel.dart';
import 'package:sandfriends/oldApp/models/enums.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';

class MatchSearchScreen extends StatefulWidget {
  int sportId;
  MatchSearchScreen({
    required this.sportId,
  });

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
            appBarType: AppBarType.Primary,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.widgetForm,
            onTapBackground: () => viewModel.closeModal(),
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
