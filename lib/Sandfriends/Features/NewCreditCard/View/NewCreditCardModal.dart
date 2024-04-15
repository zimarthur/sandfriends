import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/NewCreditCard/View/NewCreditCardWidget.dart';

import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/NewCreditCardViewModel.dart';

class NewCreditCardModal extends StatefulWidget {
  NewCreditCardModal({super.key});

  @override
  State<NewCreditCardModal> createState() => _NewCreditCardModalState();
}

class _NewCreditCardModalState extends State<NewCreditCardModal> {
  final viewModel = NewCreditCardViewModel();

  @override
  void initState() {
    viewModel.initNewCreditCard(
      context,
      true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryBack,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width > 400 ? 400 : width * 0.9,
      height: height * 0.7,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () =>
                  Provider.of<StandardScreenViewModel>(context, listen: false)
                      .removeLastOverlay(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: SvgPicture.asset(
                  r"assets/icon/x.svg",
                  color: textDarkGrey,
                ),
              ),
            ),
          ),
          Row(
            children: [
              SvgPicture.asset(
                r"assets/icon/credit_card.svg",
                color: primaryBlue,
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: Text(
                  "Adicionar cartão de crédito",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: NewCreditCardWidget(
              viewModel: viewModel,
            ),
          ),
        ],
      ),
    );
  }
}
