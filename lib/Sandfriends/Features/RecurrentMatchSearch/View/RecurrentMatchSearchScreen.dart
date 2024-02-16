import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/RecurrentMatchSearch/View/RecurrentMatchSearchWidget.dart';
import 'package:sandfriends/Sandfriends/Features/RecurrentMatchSearch/ViewModel/RecurrentMatchSearchViewModel.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';

class RecurrentMatchSearchScreen extends StatefulWidget {
  final int sportId;
  const RecurrentMatchSearchScreen({
    Key? key,
    required this.sportId,
  }) : super(key: key);

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
          return StandardScreen(
            viewModel: viewModel,
            titleText: viewModel.titleText,
            appBarType: AppBarType.PrimaryLightBlue,
            child: RecurrentMatchSearchWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
