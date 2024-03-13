import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/MatchSearchFilters.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/MatchSearchWidget.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/Mobile/WebHeaderMobile.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/ViewModel/LandingPageViewModel.dart';

import '../../../../../Common/Utils/Constants.dart';

class LandingPageWidgetMobile extends StatefulWidget {
  const LandingPageWidgetMobile({super.key});

  @override
  State<LandingPageWidgetMobile> createState() =>
      _LandingPageWidgetMobileState();
}

class _LandingPageWidgetMobileState extends State<LandingPageWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LandingPageViewModel>(context);
    return Column(
      children: [
        WebHeaderMobile(),
        Expanded(
          child: MatchSearchWidget(
            viewModel: viewModel,
          ),
        ),
      ],
    );
  }
}
