import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/OnboardingViewModel.dart';

class OnboardingWidgetWelcome extends StatefulWidget {
  const OnboardingWidgetWelcome({
    Key? key,
  }) : super(key: key);

  @override
  State<OnboardingWidgetWelcome> createState() =>
      _OnboardingWidgetWelcomeState();
}

class _OnboardingWidgetWelcomeState extends State<OnboardingWidgetWelcome> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);
    return Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
              SvgPicture.asset(
                r'assets/icon/happy_face.svg',
                height: 64,
                width: 64,
              ),
              Padding(padding: EdgeInsets.only(bottom: defaultPadding / 2)),
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
              Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
              const Text(
                "Você está quase pronto para agendar suas partidas e conhecer novos jogadores.",
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: defaultPadding / 2)),
              const Text(
                "Fale um pouco sobre você e comece a usar o aplicativo.",
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: defaultPadding * 2)),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: SFButton(
            buttonLabel: "Vamos lá",
            onTap: () {
              viewModel.goToOnboardingForm(context);
            },
          ),
        ),
        Expanded(flex: 2, child: Container()),
        SizedBox(
          height: 30,
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
    );
  }
}
