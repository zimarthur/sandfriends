import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/RewardsUser/View/RewardsUserWidget.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
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
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            appBarType: AppBarType.Secondary,
            titleText: viewModel.titleText,
            modalFormWidget: viewModel.formWidget,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: RewardsUserWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
