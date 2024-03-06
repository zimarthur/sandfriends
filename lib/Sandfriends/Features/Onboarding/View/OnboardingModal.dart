import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/Enum/EnumOnboardingPage.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/View/OnboardingWidgetForm.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/View/OnboardingWidgetWelcome.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/ViewModel/LandingPageViewModel.dart';

import '../../../../Common/Components/Modal/CitySelectorModal/CitySelectorModal.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/OnboardingViewModel.dart';
import 'SportSelectorModal.dart';

class OnboardingModal extends StatefulWidget {
  StandardScreenViewModel parentViewModel;
  OnboardingModal({required this.parentViewModel, super.key});

  @override
  State<OnboardingModal> createState() => _OnboardingModalState();
}

class _OnboardingModalState extends State<OnboardingModal> {
  late OnboardingViewModel viewModel;
  @override
  void initState() {
    viewModel = OnboardingViewModel(parentViewModel: widget.parentViewModel);
    viewModel.initOnboardingViewModel(
      context,
    );
    super.initState();
  }

  @override
  void dispose() {
    print("DISPOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          return Container(
              decoration: BoxDecoration(
                color: secondaryPaper,
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                border: Border.all(color: primaryDarkBlue, width: 1),
                boxShadow: const [
                  BoxShadow(blurRadius: 1, color: primaryDarkBlue)
                ],
              ),
              width: width < 400 ? width * 0.9 : 400,
              height: height < 600 ? height * 0.8 : 600,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: defaultPadding,
                        left: defaultPadding,
                        top: defaultPadding),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryBlue,
                          ),
                          child: Text(
                            "1",
                            style: TextStyle(
                                color: textWhite, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: viewModel.onboardingPage ==
                                    EnumOnboardingPage.Information
                                ? primaryBlue
                                : divider,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: viewModel.onboardingPage ==
                                    EnumOnboardingPage.Information
                                ? primaryBlue
                                : divider,
                          ),
                          child: Text(
                            "2",
                            style: TextStyle(
                                color: viewModel.onboardingPage ==
                                        EnumOnboardingPage.Information
                                    ? textWhite
                                    : textDarkGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        viewModel.onboardingPage == EnumOnboardingPage.Welcome
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius),
                                child: OnboardingWidgetWelcome())
                            : OnboardingWidgetForm(),
                  )
                ],
              ));
        },
      ),
    );
  }
}
