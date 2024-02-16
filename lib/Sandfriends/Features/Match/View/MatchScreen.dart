import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
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
          return StandardScreen(
            viewModel: viewModel,
            titleText: viewModel.titleText,
            appBarType: AppBarType.Primary,
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
