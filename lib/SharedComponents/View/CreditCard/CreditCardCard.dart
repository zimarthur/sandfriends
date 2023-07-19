import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../Model/CreditCard/CreditCardUtils.dart';

class CreditCardCard extends StatefulWidget {
  CreditCard creditCard;
  bool isEditable;
  Function(CreditCard)? onDeleteCreditCard;
  CreditCardCard({
    required this.creditCard,
    required this.isEditable,
    this.onDeleteCreditCard,
  });

  @override
  State<CreditCardCard> createState() => _CreditCardCardState();
}

class _CreditCardCardState extends State<CreditCardCard> {
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return SizedBox(
        width: layoutConstraints.maxWidth,
        height: 80,
        child: ListView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: [
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (widget.isEditable) {
                  scrollController.animateTo(
                    details.delta.dx > 0
                        ? scrollController.position.minScrollExtent
                        : scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding / 4,
                    vertical: defaultPadding / 2),
                width: layoutConstraints.maxWidth,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  border: Border.all(color: divider),
                  color: secondaryPaper,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    SvgPicture.asset(
                      creditCardImagePath(
                        getCardTypeFrmNumber(
                          widget.creditCard.cardNumber,
                        ),
                      ),
                      height: 40,
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (widget.creditCard.cardNickname != null)
                                Text("${widget.creditCard.cardNickname!} - "),
                              Text("Crédito"),
                            ],
                          ),
                          SizedBox(
                            height: defaultPadding / 4,
                          ),
                          Text(
                            encryptedCreditCardNumber(widget.creditCard),
                            style: TextStyle(color: textDarkGrey),
                          ),
                        ],
                      ),
                    ),
                    if (widget.isEditable)
                      InkWell(
                        onTap: () {
                          scrollController.animateTo(
                            scrollController.offset ==
                                    scrollController.position.maxScrollExtent
                                ? scrollController.position.minScrollExtent
                                : scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn,
                          );
                        },
                        child: SizedBox(
                          height: 80,
                          width: 60,
                          child: Center(
                            child: SvgPicture.asset(
                              r"assets\icon\three_dots.svg",
                              height: 20,
                              width: 60,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // GestureDetector(
            //   child: Container(
            //     height: 80,
            //     padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            //     child: SvgPicture.asset(
            //       r"assets\icon\edit.svg",
            //       color: textDarkGrey,
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () => widget.onDeleteCreditCard!(widget.creditCard),
              child: Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: SvgPicture.asset(
                  r"assets\icon\delete.svg",
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
