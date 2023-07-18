import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/SharedComponents/Model/PaymentStatus.dart';
import 'package:sandfriends/SharedComponents/Model/SelectedPayment.dart';
import 'package:sandfriends/SharedComponents/View/SFButton.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class InformationSection extends StatelessWidget {
  MatchViewModel viewModel;
  InformationSection({
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
            Text(
              "Detalhes da Partida",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              textScaleFactor: 1.3,
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
              SizedBox(
                height: defaultPadding / 2,
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
              SizedBox(
                height: defaultPadding / 2,
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
              SizedBox(
                height: defaultPadding / 2,
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
              SizedBox(
                height: defaultPadding / 2,
              ),
              if (viewModel.isUserMatchCreator)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Status:",
                        ),
                        Text(
                          viewModel.match.paymentStatus == PaymentStatus.Pending
                              ? "Aguardando pagamento"
                              : "Confirmada",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: viewModel.match.paymentStatus ==
                                    PaymentStatus.Pending
                                ? secondaryYellow
                                : textBlack,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: defaultPadding / 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pagamento:",
                        ),
                        Text(
                          viewModel.match.selectedPayment == SelectedPayment.Pix
                              ? "Pix"
                              : "Cartão de crédito\n1234",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    if (viewModel.match.paymentStatus ==
                            PaymentStatus.Pending &&
                        viewModel.match.selectedPayment == SelectedPayment.Pix)
                      Column(
                        children: [
                          SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Código Pix:",
                              ),
                              SFButton(
                                buttonLabel: viewModel.copyToClipboard
                                    ? "Copiado!"
                                    : "Copiar",
                                iconFirst: false,
                                iconPath: viewModel.copyToClipboard
                                    ? ""
                                    : r"assets\icon\copy_to_clipboard.svg",
                                isPrimary: viewModel.copyToClipboard,
                                textPadding: EdgeInsets.symmetric(
                                    vertical: defaultPadding / 2,
                                    horizontal: defaultPadding),
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: viewModel.match.pixCode));
                                  viewModel.setCopyToClipBoard(true);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}
