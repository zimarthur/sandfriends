import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../oldApp/models/enums.dart';
import '../ViewModel/MatchViewModel.dart';
import 'MatchWidget.dart';

class MatchScreen extends StatefulWidget {
  String matchUrl;
  MatchScreen({
    required this.matchUrl,
  });

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final viewModel = MatchViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatchViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<MatchViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: viewModel.titleText,
            appBarType: AppBarType.Primary,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: MatchWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
