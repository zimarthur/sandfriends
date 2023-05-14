import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:sandfriends/Utils/PageStatus.dart';

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
  void initState() {
    super.initState();
    viewModel.initMatchViewModel(
      context,
      widget.matchUrl,
    );
  }

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
            modalFormWidget: viewModel.formWidget,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: viewModel.isMatchInstantiated
                ? MatchWidget(
                    viewModel: viewModel,
                  )
                : Container(
                    color: secondaryBack,
                  ),
          );
        },
      ),
    );
  }
}
