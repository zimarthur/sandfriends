import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
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
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            enableToolbar: false,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: RecurrentMatchesWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
