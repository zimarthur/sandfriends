import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../oldApp/models/enums.dart';
import '../ViewModel/OpenMatchesViewModel.dart';
import 'OpenMatchesWidget.dart';

class OpenMatchesScreen extends StatefulWidget {
  const OpenMatchesScreen({Key? key}) : super(key: key);

  @override
  State<OpenMatchesScreen> createState() => _OpenMatchesScreenState();
}

class _OpenMatchesScreenState extends State<OpenMatchesScreen> {
  final viewModel = OpenMatchesViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OpenMatchesViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<OpenMatchesViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: viewModel.titleText,
            appBarType: AppBarType.Primary,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: OpenMatchesWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
