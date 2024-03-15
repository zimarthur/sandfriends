import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../Model/AppBarType.dart';
import '../../../StandardScreen/StandardScreen.dart';
import '../ViewModel/MatchViewModel.dart';
import 'Mobile/MatchWidgetMobile.dart';
import 'Web/MatchWidgetWeb.dart';

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
            titleText: viewModel.titleText,
            appBarType: AppBarType.Primary,
            child: viewModel.isMatchInstantiated
                ? MatchWidgetMobile(
                    viewModel: viewModel,
                  )
                : Container(
                    color: secondaryBack,
                  ),
            childWeb: viewModel.isMatchInstantiated
                ? MatchWidgetWeb(
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
