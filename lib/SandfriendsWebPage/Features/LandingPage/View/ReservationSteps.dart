import 'package:flutter/material.dart';

import '../../../../Common/Utils/Constants.dart';

class ReservationSteps extends StatefulWidget {
  const ReservationSteps({super.key});

  @override
  State<ReservationSteps> createState() => _ReservationStepsState();
}

class _ReservationStepsState extends State<ReservationSteps> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Reserve sua partida em poucos cliques",
          style: TextStyle(
            color: textDarkGrey,
          ),
        ),
        SizedBox(
          height: defaultPadding * 2,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(),
            ),
            ReservationStepsItem(
              item: "1",
              title: "Informe os dias e horários que quer jogar",
              description:
                  "Receba todas os horários e partidas disponíveis no resultado da sua busca",
            ),
            Expanded(
              child: Container(),
            ),
            ReservationStepsItem(
              item: "2",
              title: "Escolha a quadra e hora da partida",
              description:
                  "Ative sua localização para escolher a quadra mais perto de você!",
            ),
            Expanded(
              child: Container(),
            ),
            ReservationStepsItem(
              item: "3",
              title: "Efetue o pagamento da sua reserva",
              description:
                  "Você pode pagar pelo app e dar adeus às filas de pagamento",
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }
}

class ReservationStepsItem extends StatefulWidget {
  String item;
  String title;
  String description;
  ReservationStepsItem(
      {required this.item,
      required this.title,
      required this.description,
      super.key});

  @override
  State<ReservationStepsItem> createState() => _ReservationStepsItemState();
}

class _ReservationStepsItemState extends State<ReservationStepsItem> {
  bool onHover = false;
  double increase = 2;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (pointer) {
        setState(() {
          onHover = true;
        });
      },
      onExit: (pointer) {
        setState(() {
          onHover = false;
        });
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300 + (onHover ? increase : 0),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(
            defaultBorderRadius - (onHover ? increase : 0),
          ),
          decoration: BoxDecoration(
            color: secondaryPaper,
            border: Border.all(
              color: primaryDarkBlue,
              width: 2 + (onHover ? increase : 0),
            ),
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
            boxShadow: onHover
                ? [
                    BoxShadow(
                      blurRadius: 2,
                      offset: Offset(0, 0),
                      color: primaryDarkBlue,
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.item,
                style: TextStyle(),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryDarkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textDarkGrey,
                  fontWeight: FontWeight.w200,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
