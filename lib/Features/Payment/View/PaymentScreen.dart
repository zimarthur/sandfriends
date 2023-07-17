import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Payment/View/PaymentWidget.dart';
import 'package:sandfriends/Features/Payment/ViewModel/PaymentViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final viewModel = PaymentViewModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<PaymentViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<PaymentViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            titleText: "Formas de Pagamento",
            onTapReturn: () => viewModel.goToHome(context),
            onTapBackground: () => viewModel.closeModal(),
            messageModalWidget: viewModel.modalMessage,
            pageStatus: viewModel.pageStatus,
            appBarType: AppBarType.Secondary,
            child: PaymentWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
