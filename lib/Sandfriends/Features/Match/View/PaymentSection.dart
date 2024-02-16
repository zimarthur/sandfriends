import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Common/Components/PixCodeClipboard.dart';
import '../../../../Common/Model/PaymentStatus.dart';
import '../../../../Common/Model/SelectedPayment.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class PaymentSection extends StatefulWidget {
  final MatchViewModel viewModel;
  final VoidCallback onExpired;
  const PaymentSection({
    super.key,
    required this.viewModel,
    required this.onExpired,
  });

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
        widget.onExpired();
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
                        ? widget.viewModel.match.selectedPayment ==
                                SelectedPayment.CreditCard
                            ? "Processando pagamento"
                            : "Aguardando pagamento"
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
                widget.viewModel.match.isFromRecurrentMatch()
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            color: primaryBlue),
                        margin: EdgeInsets.only(top: defaultPadding),
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Column(
                          children: [
                            const Text(
                              "Partida mensalista:\nEncontre as informações de pagamento na Área do Mensalista",
                              style: TextStyle(color: textWhite),
                            ),
                            const SizedBox(
                              height: defaultPadding / 2,
                            ),
                            SFButton(
                                buttonLabel: "Ir para Área do Mensalista",
                                isPrimary: false,
                                textPadding: EdgeInsets.symmetric(
                                    vertical: defaultPadding / 2),
                                onTap: () => Navigator.pushNamed(
                                    context, "/recurrent_matches")),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Código Pix ',
                              style: const TextStyle(
                                  fontFamily: 'Lexend', color: textBlack),
                              children: [
                                TextSpan(
                                  text:
                                      "(${widget.viewModel.copyToClipboard ? "copiado!" : "toque para copiar"})",
                                  style: const TextStyle(
                                    color: textDarkGrey,
                                    fontFamily: 'Lexend',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          PixCodeClipboard(
                            pixCode: widget.viewModel.match.pixCode!,
                            hasCopiedPixToClipboard:
                                widget.viewModel.copyToClipboard,
                            onCopied: () =>
                                widget.viewModel.setCopyToClipBoard(true),
                            mainColor: primaryBlue,
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
