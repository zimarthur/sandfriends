import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/Payment/CheckoutPaymentRadio.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../../Common/Model/CreditCard/CreditCardUtils.dart';
import '../../../../../../Common/Components/SFTextField.dart';

class CheckoutPayment extends StatefulWidget {
  CheckoutViewModel viewModel;
  final bool showTitle;
  final bool showOnlySelected;
  CheckoutPayment({
    this.showTitle = true,
    required this.viewModel,
    this.showOnlySelected = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutPayment> createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showTitle)
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding / 2),
                child: Text(
                  "Forma de pagamento",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1.3,
                ),
              ),
            if (widget.showOnlySelected == false ||
                widget.viewModel.selectedPayment ==
                    SelectedPayment.NotSelected ||
                widget.viewModel.selectedPayment == SelectedPayment.Pix)
              CheckoutPaymentRadio(
                radioPaymentValue: SelectedPayment.Pix,
                radioPaymentSelected: widget.viewModel.selectedPayment,
                iconPath: r"assets/icon/pix.svg",
                title: "Pix",
                onTap: (newSelectedPayment) => widget.viewModel
                    .setNewSelectedPayment(context, newSelectedPayment),
                childWhenSelected: Padding(
                  padding: const EdgeInsets.only(top: defaultPadding / 2),
                  child: SFTextField(
                    labelText: "Cpf para a nota fiscal",
                    pourpose: TextFieldPourpose.Numeric,
                    controller: widget.viewModel.cpfController,
                    focusNode: widget.viewModel.cpfFocus,
                    validator: (value) => cpfValidator(value, null),
                  ),
                ),
              ),
            if (widget.showOnlySelected == false ||
                widget.viewModel.selectedPayment ==
                    SelectedPayment.NotSelected ||
                widget.viewModel.selectedPayment == SelectedPayment.CreditCard)
              CheckoutPaymentRadio(
                radioPaymentValue: SelectedPayment.CreditCard,
                radioPaymentSelected: widget.viewModel.selectedPayment,
                iconPath: widget.viewModel.selectedPayment ==
                        SelectedPayment.CreditCard
                    ? creditCardImagePath(
                        widget.viewModel.selectedCreditCard!.cardType,
                      )
                    : r"assets/icon/credit_card.svg",
                title: widget.viewModel.selectedPayment ==
                        SelectedPayment.CreditCard
                    ? widget.viewModel.selectedCreditCard!.cardNickname != null
                        ? "${widget.viewModel.selectedCreditCard!.cardNickname} - Crédito"
                        : "Crédito"
                    : "Cartão de crédito",
                subtitle: null,
                onTap: (newSelectedPayment) => widget.viewModel
                    .setNewSelectedPayment(context, newSelectedPayment),
                childWhenSelected: Padding(
                  padding: const EdgeInsets.only(top: defaultPadding / 2),
                  child: SFTextField(
                    labelText: "Cvv",
                    pourpose: TextFieldPourpose.Numeric,
                    controller: widget.viewModel.cvvController,
                    focusNode: widget.viewModel.cvvFocus,
                    validator: (value) => validateCVV(
                      value,
                    ),
                  ),
                ),
              ),
            if (widget.showTitle)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: defaultPadding / 2, top: defaultPadding / 4),
                    child: Row(children: [
                      SvgPicture.asset(
                        r"assets/icon/star.svg",
                        color: secondaryYellow,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          textScaleFactor: 0.8,
                          text: TextSpan(
                            text: 'Pague pelo app para conquistar ',
                            style: const TextStyle(
                              color: textDarkGrey,
                              fontFamily: 'Lexend',
                            ),
                            children: [
                              TextSpan(
                                text: "recompensas",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: secondaryYellow,
                                  fontFamily: 'Lexend',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: divider,
                    ),
                  ),
                ],
              ),
            if (widget.showOnlySelected == false ||
                widget.viewModel.selectedPayment ==
                    SelectedPayment.NotSelected ||
                widget.viewModel.selectedPayment == SelectedPayment.PayInStore)
              CheckoutPaymentRadio(
                radioPaymentValue: SelectedPayment.PayInStore,
                radioPaymentSelected: widget.viewModel.selectedPayment,
                iconPath: r"assets/icon/dollar_bill.svg",
                title: "Pagar no local",
                subtitle: null,
                onTap: (newSelectedPayment) => widget.viewModel
                    .setNewSelectedPayment(context, newSelectedPayment),
              ),
          ],
        ),
        if (Provider.of<UserProvider>(context).user == null) ...[
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: InkWell(
              onTap:
                  () {}, //apenas para impedir o clique dos radios de pagamento
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY: 2.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: width * 0.7,
                  height: 120,
                  child: ClipRRect(
                    child: InkWell(
                      onTap: () => widget.viewModel.onTapLogin(context),
                      child: Container(
                        padding: EdgeInsets.all(
                          defaultPadding,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius,
                          ),
                          color: primaryBlue,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              r"assets/icon/user.svg",
                              color: textWhite,
                              height: 40,
                            ),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            Text(
                              "Faça login para finalizar sua reserva",
                              style: TextStyle(
                                color: textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // alignment: Alignment.center,
                    // width: 200.0,
                    // height: 200.0,
                    // child: Text('Hello World'),
                  ),
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
