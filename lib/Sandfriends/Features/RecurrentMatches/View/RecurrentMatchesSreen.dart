import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../ViewModel/RecurrentMatchesViewModel.dart';
import 'RecurrentMatchesWidget.dart';

class RecurrentMatchesScreen extends StatefulWidget {
  const RecurrentMatchesScreen({Key? key}) : super(key: key);

  @override
  State<RecurrentMatchesScreen> createState() => _RecurrentMatchesScreenState();
}

class _RecurrentMatchesScreenState extends State<RecurrentMatchesScreen> {
  final viewModel = RecurrentMatchesViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecurrentMatchesViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<RecurrentMatchesViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            enableToolbar: false,
            background: secondaryBack,
            child: RecurrentMatchesWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
