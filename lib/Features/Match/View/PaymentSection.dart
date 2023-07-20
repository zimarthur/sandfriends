import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../SharedComponents/Model/PaymentStatus.dart';
import '../../../SharedComponents/Model/SelectedPayment.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class PaymentSection extends StatelessWidget {
  MatchViewModel viewModel;
  PaymentSection({required this.viewModel});

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
              "Pagamento",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              textScaleFactor: 1.3,
            ),
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
                    "Status:",
                  ),
                  Text(
                    viewModel.match.paymentStatus == PaymentStatus.Pending
                        ? "Aguardando pagamento"
                        : "Confirmado",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color:
                          viewModel.match.paymentStatus == PaymentStatus.Pending
                              ? secondaryYellow
                              : Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Forma de pagamento:",
                  ),
                  Text(
                    viewModel.match.selectedPayment == SelectedPayment.Pix
                        ? "Pix"
                        : "Cartão de crédito\n${viewModel.match.creditCard!.cardNumber}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (viewModel.match.paymentStatus == PaymentStatus.Pending &&
                  viewModel.match.selectedPayment == SelectedPayment.Pix)
                Column(
                  children: [
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Código Pix:",
                        ),
                        SFButton(
                          buttonLabel:
                              viewModel.copyToClipboard ? "Copiado!" : "Copiar",
                          iconFirst: false,
                          iconPath: viewModel.copyToClipboard
                              ? ""
                              : r"assets\icon\copy_to_clipboard.svg",
                          isPrimary: viewModel.copyToClipboard,
                          textPadding: EdgeInsets.symmetric(
                              vertical: defaultPadding / 2,
                              horizontal: defaultPadding),
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: viewModel.match.pixCode));
                            viewModel.setCopyToClipBoard(true);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        )
      ],
    );
  }
}
