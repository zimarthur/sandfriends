import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/CourtViewModel.dart';
import 'CourtWidget.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({Key? key}) : super(key: key);

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  final viewModel = CourtViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CourtViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CourtViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            enableToolbar: false,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: CourtWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
