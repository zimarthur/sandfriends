import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/RecurrentMatchSearch/View/RecurrentMatchSearchWidget.dart';
import 'package:sandfriends/Features/RecurrentMatchSearch/ViewModel/RecurrentMatchSearchViewModel.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../oldApp/models/enums.dart';

class RecurrentMatchSearchScreen extends StatefulWidget {
  int sportId;
  RecurrentMatchSearchScreen({
    required this.sportId,
  });

  @override
  State<RecurrentMatchSearchScreen> createState() =>
      _RecurrentMatchSearchScreenState();
}

class _RecurrentMatchSearchScreenState
    extends State<RecurrentMatchSearchScreen> {
  final viewModel = RecurrentMatchSearchViewModel();

  @override
  void initState() {
    viewModel.initRecurrentMatchSearchViewModel(context, widget.sportId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecurrentMatchSearchViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<RecurrentMatchSearchViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: viewModel.titleText,
            appBarType: AppBarType.PrimaryLightBlue,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.widgetForm,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: RecurrentMatchSearchWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
