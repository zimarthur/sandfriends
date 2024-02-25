import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/ViewModel/AppInfoViewModel.dart';

import '../../../../Common/Utils/Constants.dart';

class AppInfoWidget extends StatelessWidget {
  final AppInfoViewModel viewModel;
  const AppInfoWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: secondaryBack,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: height * 0.1,
          ),
          Image.asset(
            r"assets/icon/logo_brand.png",
            height: height * 0.2,
          ),
          SizedBox(
            height: height * 0.1,
          ),
          const Text(
            "Versão",
            style: TextStyle(
              color: textDarkGrey,
            ),
          ),
          Text(
            viewModel.appVersion,
            textScaleFactor: 2,
          ),
          Expanded(child: Container()),
          Column(
            children: [
              InkWell(
                onTap: () => viewModel.onTapTerms(context),
                child: const Text(
                  "Termos de uso",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: textDarkGrey,
                    decorationColor: textDarkGrey,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: defaultPadding / 2,
                ),
              ),
              InkWell(
                onTap: () => viewModel.onTapPrivacy(context),
                child: const Text(
                  "Política de privacidade",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: textDarkGrey,
                    decorationColor: textDarkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.05,
          ),
          InkWell(
            onTap: () => viewModel.onDeleteAccount(context),
            child: RichText(
              maxLines: 2,
              textScaleFactor: 0.8,
              text: TextSpan(
                text: 'Toque aqui',
                style: const TextStyle(
                  color: red,
                  fontFamily: 'Lexend',
                ),
                children: [
                  TextSpan(
                    text: " se você deseja excluir sua conta.",
                    style:
                        const TextStyle(fontFamily: 'Lexend', color: textBlack),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.1,
          ),
        ],
      ),
    );
  }
}
