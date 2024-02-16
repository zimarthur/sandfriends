import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../Model/Coupon.dart';

class CheckoutBottomToolbarDiscount extends StatefulWidget {
  CheckoutViewModel viewModel;

  CheckoutBottomToolbarDiscount({
    required this.viewModel,
    super.key,
  });

  @override
  State<CheckoutBottomToolbarDiscount> createState() =>
      _CheckoutBottomToolbarDiscountState();
}

class _CheckoutBottomToolbarDiscountState
    extends State<CheckoutBottomToolbarDiscount> {
  @override
  Widget build(BuildContext context) {
    bool hasAppliedCoupon = widget.viewModel.appliedCoupon != null;
    return InkWell(
      onTap: () => widget.viewModel.onAddCupom(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasAppliedCoupon
              ? const Column(
                  children: [
                    Text(
                      "Tem cupom? ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding / 4,
                    ),
                  ],
                )
              : Container(),
          Row(
            children: [
              !hasAppliedCoupon
                  ? Row(
                      children: [
                        Text(
                          "Tem cupom? ",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding / 4,
                        ),
                      ],
                    )
                  : Container(),
              SvgPicture.asset(r"assets/icon/discount.svg"),
              SizedBox(
                width: defaultPadding / 4,
              ),
              Text(
                hasAppliedCoupon
                    ? widget.viewModel.appliedCoupon!.couponCode
                    : "Digite aqui!",
                style: const TextStyle(
                  fontSize: 12,
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              if (hasAppliedCoupon)
                Text(
                  "R\$ -${widget.viewModel.appliedCoupon!.calculateDiscount(widget.viewModel.matchPrice).toStringAsFixed(2).replaceAll(".", ",")}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
