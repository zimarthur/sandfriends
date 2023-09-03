import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../SharedComponents/Model/PaymentStatus.dart';
import '../../../SharedComponents/Model/SelectedPayment.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class PaymentSection extends StatefulWidget {
  final MatchViewModel viewModel;
  const PaymentSection({super.key, required this.viewModel});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.viewModel.match.isPaymentExpired == false) {
        widget.viewModel.setLiveDateTime(DateTime.now());
      } else {
        widget.viewModel.getMatchInfo(
          context,
          widget.viewModel.match.matchUrl,
        );
        _timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
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
                    widget.viewModel.match.paymentStatus ==
                            PaymentStatus.Pending
                        ? "Aguardando pagamento"
                        : "Confirmado",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: widget.viewModel.match.paymentStatus ==
                              PaymentStatus.Pending
                          ? secondaryYellow
                          : Colors.green,
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
                    "Forma de pagamento:",
                  ),
                  Text(
                    widget.viewModel.match.selectedPayment ==
                            SelectedPayment.Pix
                        ? "Pix"
                        : widget.viewModel.match.selectedPayment ==
                                SelectedPayment.CreditCard
                            ? "Cartão de crédito\n${widget.viewModel.match.creditCard!.cardNumber}"
                            : "Pagar no local",
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (widget.viewModel.match.paymentStatus ==
                      PaymentStatus.Pending &&
                  widget.viewModel.match.selectedPayment == SelectedPayment.Pix)
                Column(
                  children: [
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Código Pix:",
                        ),
                        SFButton(
                          buttonLabel: widget.viewModel.copyToClipboard
                              ? "Copiado!"
                              : "Copiar",
                          iconFirst: false,
                          iconPath: widget.viewModel.copyToClipboard
                              ? ""
                              : r"assets/icon/copy_to_clipboard.svg",
                          isPrimary: widget.viewModel.copyToClipboard,
                          textPadding: const EdgeInsets.symmetric(
                              vertical: defaultPadding / 2,
                              horizontal: defaultPadding),
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                                text: widget.viewModel.match.pixCode!));
                            widget.viewModel.setCopyToClipBoard(true);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Você tem ',
                        style: const TextStyle(
                          color: textDarkGrey,
                          fontFamily: 'Lexend',
                        ),
                        children: [
                          TextSpan(
                            text: widget.viewModel.timeToExpirePayment,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textBlue,
                              fontFamily: 'Lexend',
                            ),
                          ),
                          const TextSpan(
                            text: " minutos para finalizar o pagamento",
                            style: TextStyle(
                              color: textDarkGrey,
                              fontFamily: 'Lexend',
                            ),
                          ),
                          const TextSpan(text: "."),
                        ],
                      ),
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
