import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Store/View/StoreWidget.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Store/ViewModel/StoreViewModel.dart';

class StoreScreen extends StatelessWidget {
  StoreScreen({super.key});

  final viewModel = StoreViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<StoreViewModel>(builder: (context, viewModel, _) {
        return StandardScreen(
          viewModel: viewModel,
          child: Container(),
          childWeb: StoreWidget(),
        );
      }),
    );
  }
}
