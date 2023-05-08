import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../oldApp/models/enums.dart';
import '../ViewModel/RewardsViewModel.dart';
import 'RewardsWidget.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final viewModel = RewardsViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewardsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<RewardsViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: viewModel.titleText,
            appBarType: AppBarType.Secondary,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: RewardsWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
