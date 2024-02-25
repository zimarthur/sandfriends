import 'package:flutter/material.dart';
import '../../../../../../Common/Utils/Constants.dart';

class ResumedInfoRowHeader extends StatelessWidget {
  const ResumedInfoRowHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text(
              "Dia",
              style: TextStyle(color: textLightGrey),
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              "Horário",
              style: TextStyle(color: textLightGrey),
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              "Aceita\nMensalista?",
              style: TextStyle(color: textLightGrey),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Preço avulso\n',
                style: TextStyle(
                  color: textLightGrey,
                  fontFamily: 'Lexend',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Preço Mensalista',
                    style: TextStyle(
                      color: textBlue,
                      fontFamily: 'Lexend',
                      //fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: (2 * defaultPadding) + 20,
          ),
        ],
      ),
    );
  }
}
