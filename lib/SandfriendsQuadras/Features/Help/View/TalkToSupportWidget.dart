import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/View/SFButton.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../ViewModel/HelpViewModel.dart';

class TalkToSupportWidget extends StatelessWidget {
  TalkToSupportWidget({super.key});

  final HelpViewModel viewModel = HelpViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HelpViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<HelpViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            height: 300,
            width: 500,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryPaper,
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              border: Border.all(
                color: divider,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Fale com a nossa equipe",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text(
                      "Retornaremos em até 24 horas",
                      style: TextStyle(color: textDarkGrey, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryBlue.withOpacity(0.3)),
                      child: SvgPicture.asset(
                        r'assets/icon/email.svg',
                        color: primaryBlue,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    const Text(
                      "contato@sandfriends.com.br",
                      style: TextStyle(color: textBlue),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: green.withOpacity(0.3)),
                      child: SvgPicture.asset(
                        r'assets/icon/whatsapp.svg',
                        color: green,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    const Text(
                      "(51) 99330-8831",
                      style: TextStyle(color: green),
                    )
                  ],
                ),
                SFButton(
                    buttonLabel: "Voltar",
                    buttonType: ButtonType.Secondary,
                    onTap: () {
                      viewModel.returnMainView(context);
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}
