import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/RewardsUser/View/RewardsUserWidget.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../ViewModel/RewardsUserViewModel.dart';

class RewardsUserScreen extends StatefulWidget {
  const RewardsUserScreen({Key? key}) : super(key: key);

  @override
  State<RewardsUserScreen> createState() => _RewardsUserScreenState();
}

class _RewardsUserScreenState extends State<RewardsUserScreen> {
  final viewModel = RewardsUserViewModel();

  @override
  void initState() {
    viewModel.initRewardsUserScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewardsUserViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<RewardsUserViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            appBarType: AppBarType.Secondary,
            titleText: "Minhas Recompensas",
            child: RewardsUserWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
