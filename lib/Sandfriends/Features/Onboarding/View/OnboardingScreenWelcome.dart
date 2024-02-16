import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/OnboardingViewModel.dart';

class OnboardingWidgetWelcome extends StatefulWidget {
  final OnboardingViewModel viewModel;
  const OnboardingWidgetWelcome({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<OnboardingWidgetWelcome> createState() =>
      _OnboardingWidgetWelcomeState();
}

class _OnboardingWidgetWelcomeState extends State<OnboardingWidgetWelcome> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (BuildContext context) => widget.viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            viewModel: viewModel,
            titleText: "Boas-vindas",
            appBarType: AppBarType.Secondary,
            child: Container(
              color: secondaryBack,
              width: double.infinity,
              child: Container(
                color: secondaryBack,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.09),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.09)),
                          SvgPicture.asset(
                            r'assets/icon/happy_face.svg',
                            height: height * 0.13,
                            width: height * 0.13,
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.02)),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Boas-vindas,",
                                style: TextStyle(
                                  color: textBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                "Sandfriend!",
                                style: TextStyle(
                                  color: textBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.03)),
                          const Text(
                            "Você está quase pronto para agendar suas partidas e conhecer novos jogadores.",
                            style: TextStyle(
                              color: textBlue,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.015)),
                          const Text(
                            "Fale um pouco sobre você e comece a usar o aplicativo.",
                            style: TextStyle(
                              color: textBlue,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.12)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: height * 0.05,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                        child: SFButton(
                          buttonLabel: "Vamos lá",
                          onTap: () {
                            widget.viewModel.goToOnboardingForm(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      height: height * 0.06,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SvgPicture.asset(
                          r'assets/icon/sand_bar.svg',
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
