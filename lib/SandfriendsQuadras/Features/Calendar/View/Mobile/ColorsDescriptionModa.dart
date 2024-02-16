import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Utils/Constants.dart';

class ColorsDescriptionModal extends StatefulWidget {
  final VoidCallback onReturn;

  ColorsDescriptionModal({
    required this.onReturn,
    super.key,
  });

  @override
  State<ColorsDescriptionModal> createState() => _ColorsDescriptionModalState();
}

class _ColorsDescriptionModalState extends State<ColorsDescriptionModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      height: height * 0.7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => widget.onReturn(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    child: SvgPicture.asset(
                      r"assets/icon/x.svg",
                      color: textDarkGrey,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Legenda de cores do app",
                    style: TextStyle(
                      color: textDarkGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  ColorsDescriptionItem(
                    color: match,
                    colorBg: matchBg,
                    text: "Partidas agendadas pelo app",
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  ColorsDescriptionItem(
                    color: recurrentMatch,
                    colorBg: recurrentMatchBg,
                    text: "Mensalistas agendadas pelo app",
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  ColorsDescriptionItem(
                    color: secondaryYellowDark,
                    colorBg: secondaryYellowDark50,
                    text: "Partidas/Mensalistas agendadas pela quadra",
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(r"assets/icon/already_paid.svg"),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: Text(
                          "Partida já paga pelo app",
                          style: TextStyle(
                            color: textDarkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(r"assets/icon/needs_payment.svg"),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: Text(
                          "Pagamento deve ser feito na quadra",
                          style: TextStyle(
                            color: textDarkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorsDescriptionItem extends StatelessWidget {
  Color color;
  Color colorBg;
  String text;
  ColorsDescriptionItem(
      {required this.color,
      required this.colorBg,
      required this.text,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 40,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: colorBg,
              borderRadius: BorderRadius.circular(defaultBorderRadius / 2)),
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: defaultPadding / 2,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
