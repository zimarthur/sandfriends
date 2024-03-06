import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../../Common/Components/CreditCard/CreditCardWidget.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Utils/Constants.dart';

class ModalCreditCardSelector extends StatelessWidget {
  final Function(CreditCard) onSelectedCreditCard;
  VoidCallback onAddNewCreditCard;
  VoidCallback closeModal;
  ModalCreditCardSelector({
    super.key,
    required this.onSelectedCreditCard,
    required this.onAddNewCreditCard,
    required this.closeModal,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9 > 400 ? 400 : width * 0.9,
      height: height * 0.6 > 600 ? 600 : width * 0.6,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => closeModal(),
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
                    onSelectedCreditCard(creditCard),
              ),
            ),
          ),
          SFButton(
            buttonLabel: "Novo cartão de crédito",
            onTap: () => onAddNewCreditCard(),
            textPadding:
                const EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
