import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerManager.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

class LandingPageFooter extends StatelessWidget {
  const LandingPageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      color: primaryBlue,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.1, vertical: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(r"assets/logo_64.png"),
              InkWell(
                onTap: () =>
                    LinkOpenerManager().openLink(context, privacyPolicy),
                child: const Text(
                  "Política de Privacidade",
                  style: TextStyle(
                    color: textWhite,
                    decoration: TextDecoration.underline,
                    decorationColor: textWhite,
                  ),
                ),
              ),
              InkWell(
                onTap: () => LinkOpenerManager().openLink(context, termsUse),
                child: const Text(
                  "Termos de uso",
                  style: TextStyle(
                    color: textWhite,
                    decoration: TextDecoration.underline,
                    decorationColor: textWhite,
                  ),
                ),
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sandfriends® é uma marca registrada de",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 12,
                ),
              ),
              Text(
                "SANDFRIENDS TECNOLOGIA PARA ESPORTES LTDA.",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 12,
                ),
              ),
              Text(
                "52.157.123/0001-34",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 12,
                ),
              ),
              Text(
                "Todos os direitos reservados",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () =>
                    LinkOpenerManager().openLink(context, whatsAppLink),
                child: SvgPicture.asset(
                  r"assets/icon/whatsapp.svg",
                  color: textWhite,
                  height: 30,
                ),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              InkWell(
                onTap: () =>
                    LinkOpenerManager().openLink(context, instagramLink),
                child: SvgPicture.asset(
                  r"assets/icon/instagram.svg",
                  color: textWhite,
                  height: 30,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
