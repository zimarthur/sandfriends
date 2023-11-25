import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class InformationSection extends StatelessWidget {
  final MatchViewModel viewModel;
  const InformationSection({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Detalhes da Partida",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              textScaleFactor: 1.3,
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            viewModel.match.canceled || viewModel.match.isPaymentExpired
                ? Expanded(
                    child: Text(
                      viewModel.match.canceled
                          ? "Cancelada"
                          : "Pagamento Expirado",
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.red),
                    ),
                  )
                : viewModel.match.date.isBefore(DateTime.now())
                    ? SizedBox(
                        height: height * 0.03,
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Encerrada",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: textLightGrey,
                            ),
                          ),
                        ),
                      )
                    : Container()
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: defaultPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Data:",
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(viewModel.match.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Horário:",
                  ),
                  Text(
                    "${viewModel.match.timeBegin.hourString} - ${viewModel.match.timeEnd.hourString}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Esporte:",
                  ),
                  Text(
                    viewModel.match.sport.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Preço:",
                  ),
                  Text(
                    "R\$ ${viewModel.match.cost.toInt()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
