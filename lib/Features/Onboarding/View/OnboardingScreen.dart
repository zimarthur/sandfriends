import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Onboarding/ViewModel/OnboardingViewModel.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../oldApp/models/enums.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final viewModel = OnboardingViewModel();

  @override
  void initState() {
    viewModel.initOnboardingViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          return viewModel.displayWidget;
        },
      ),
    );
  }
}
