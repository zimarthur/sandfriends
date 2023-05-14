import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class InformationSection extends StatelessWidget {
  MatchViewModel viewModel;
  InformationSection({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height * 0.03,
                child: const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    "Detalhes da Partida",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              viewModel.match.canceled
                  ? SizedBox(
                      height: height * 0.03,
                      child: const FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "Cancelada",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.red),
                        ),
                      ),
                    )
                  : viewModel.match.date.isBefore(DateTime.now())
                      ? SizedBox(
                          height: height * 0.03,
                          child: FittedBox(
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Horário:",
                      ),
                      Text(
                        "${viewModel.match.timeBegin} - ${viewModel.match.timeFinish}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Preço:",
                      ),
                      Text(
                        "R\$ ${viewModel.match.cost}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
