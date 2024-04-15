import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/Enum/EnumOnboardingPage.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/View/OnboardingWidgetForm.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/View/OnboardingWidgetWelcome.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../ViewModel/OnboardingViewModel.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final viewModel = OnboardingViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.initOnboardingViewModel(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: viewModel.onboardingPage == EnumOnboardingPage.Welcome
                ? "Boas-vindas"
                : "Meu perfil",
            appBarType: AppBarType.Secondary,
            customOnTapReturn: () => viewModel.onTapReturn(context),
            child: viewModel.onboardingPage == EnumOnboardingPage.Welcome
                ? OnboardingWidgetWelcome()
                : OnboardingWidgetForm(),
          );
        },
      ),
    );
  }
}
