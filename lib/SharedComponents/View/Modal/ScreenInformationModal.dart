import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SharedComponents/Model/ScreenInformation.dart';
import 'package:sandfriends/SharedComponents/View/SFButton.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenInformationModal extends StatefulWidget {
  final String title;
  final List<ScreenInformation> screenInformations;
  final VoidCallback onReturn;
  const ScreenInformationModal({
    Key? key,
    required this.title,
    required this.screenInformations,
    required this.onReturn,
  }) : super(key: key);

  @override
  State<ScreenInformationModal> createState() => _ScreenInformationModalState();
}

class _ScreenInformationModalState extends State<ScreenInformationModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: defaultPadding,
      ),
      width: width * 0.9,
      height: height * 0.9,
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.3,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              for (var screenInformation in widget.screenInformations)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: defaultBorderRadius / 2,
                  ),
                  child: Column(children: [
                    Text(
                      screenInformation.question,
                      style: TextStyle(
                        color: textBlue,
                      ),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.1,
                    ),
                    SizedBox(
                      height: defaultPadding / 4,
                    ),
                    Text(
                      screenInformation.answer,
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                      textScaleFactor: 0.9,
                      textAlign: TextAlign.center,
                    )
                  ]),
                ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                    vertical: defaultBorderRadius * 2),
                height: 2,
                width: double.infinity,
                color: divider,
              ),
              InkWell(
                onTap: () {
                  final url = Uri.parse("whatsapp://send?phone=$whatsApp");
                  launchUrl(url);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      border: Border.all(color: green, width: 2)),
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Ficou com alguma dúvida?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textWhite,
                              ),
                            ),
                            Text(
                              "Nos chame pelo WhatsApp!",
                              style: TextStyle(color: textWhite),
                              textScaleFactor: 0.9,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        r"assets/icon/whatsapp.svg",
                        color: textWhite,
                      ),
                    ],
                  ),
                ),
              )
            ]),
          )),
          SizedBox(
            height: defaultPadding,
          ),
          SFButton(
            buttonLabel: "Voltar",
            onTap: () => widget.onReturn(),
            textPadding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
