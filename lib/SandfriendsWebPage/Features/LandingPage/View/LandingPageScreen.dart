import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/Mobile/LandingPageWidgetMobile.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/Mobile/SandfriendsWebDrawer.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/Web/LandingPageWidgetWeb.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/ViewModel/LandingPageViewModel.dart';

class LandingPageScreen extends StatefulWidget {
  LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  final viewModel = LandingPageViewModel();

  @override
  void initState() {
    viewModel.initLandingPageViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LandingPageViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<LandingPageViewModel>(builder: (context, viewModel, _) {
        return StandardScreen(
          enableToolbar: false,
          background: secondaryBack,
          child: LandingPageWidgetMobile(),
          childWeb: LandingPageWidgetWeb(),
          drawer: SandfriendsWebDrawer(
            onTapLogin: () => viewModel.onTapLoginDrawer(context),
            onTapProfile: () => viewModel.onTapProfile(context),
            onTapMatches: () => viewModel.onTapMatches(context),
          ),
        );
      }),
    );
  }
}
