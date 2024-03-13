import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../../Common/Components/CreditCard/CreditCardWidget.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Responsive.dart';

class ModalCreditCardSelector extends StatefulWidget {
  final Function(CreditCard) onSelectedCreditCard;
  VoidCallback onAddNewCreditCard;
  ModalCreditCardSelector({
    super.key,
    required this.onSelectedCreditCard,
    required this.onAddNewCreditCard,
  });

  @override
  State<ModalCreditCardSelector> createState() =>
      _ModalCreditCardSelectorState();
}

class _ModalCreditCardSelectorState extends State<ModalCreditCardSelector> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9 > 400 ? 400 : width * 0.9,
      height: Responsive.isMobile(context)
          ? height * 0.8
          : height > 600
              ? 600
              : width * 0.6,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () =>
                  Provider.of<StandardScreenViewModel>(context, listen: false)
                      .removeLastOverlay(),
              child: SvgPicture.asset(
                r"assets/icon/x.svg",
                color: textDarkGrey,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
                vertical: defaultPadding,
              ),
              child: CreditCardWidget(
                creditCards: Provider.of<UserProvider>(context).creditCards,
                isEditable: false,
                onSelectedCreditCard: (creditCard) =>
                    widget.onSelectedCreditCard(creditCard),
              ),
            ),
          ),
          SFButton(
            buttonLabel: "Novo cartão de crédito",
            onTap: () => widget.onAddNewCreditCard(),
            textPadding:
                const EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
