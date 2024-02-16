import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../Utils/Constants.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';

class NoCourtsFound extends StatelessWidget {
  const NoCourtsFound({super.key});

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          r'assets/people/calendar.svg',
          height: width * 0.25,
          width: width * 0.4,
        ),
        SizedBox(
          width: width * 0.5,
          child: Column(
            children: const [
              Text(
                "Você ainda não adicionou nenhuma quadra",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Text(
                "Clique na aba \"Minhas quadras\" para finalizar o cadastro e conseguir acompanhar seus agendamentos",
                style: TextStyle(
                  color: textLightGrey,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ],
    );
  }
}
