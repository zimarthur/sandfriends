import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/MatchViewModel.dart';
import 'MatchWidget.dart';

class MatchScreen extends StatefulWidget {
  final String matchUrl;
  const MatchScreen({
    Key? key,
    required this.matchUrl,
  }) : super(key: key);

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
            canTapBackground: viewModel.canTapBackground,
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
