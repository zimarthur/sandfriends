import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Sandfriends/Features/NewCreditCard/View/NewCreditCardWidget.dart';

import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/NewCreditCardViewModel.dart';

class NewCreditCardModal extends StatefulWidget {
  VoidCallback close;
  NewCreditCardModal({required this.close, super.key});

  @override
  State<NewCreditCardModal> createState() => _NewCreditCardModalState();
}

class _NewCreditCardModalState extends State<NewCreditCardModal> {
  final viewModel = NewCreditCardViewModel();

  @override
  void initState() {
    viewModel.initNewCreditCard(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
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
              onTap: () => widget.close(),
              child: SvgPicture.asset(
                r"assets/icon/x.svg",
                color: textDarkGrey,
              ),
            ),
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
